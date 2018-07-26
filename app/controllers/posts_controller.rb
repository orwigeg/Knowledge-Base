require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'securerandom'

class PostsController < ApplicationController

	def index
		@posts = Post.all
	end

	def show
		@post = Post.find(params[:id])
		@translated_title = translate_text(@post.title)
		@translated_body = translate_text(@post.body)
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		if @post.valid?
			@post.save
			redirect_to @post
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		@post.update(post_params)
		redirect_to @post
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		redirect_to posts_path
	end

	private def post_params
		params.require(:post).permit(:title, :body)
	end

	private def translate_text(text)
		#Currently invalid
		key = 'c42555b0acce4d2ca6ed329666a21acc' 
		
		host = 'https://api.cognitive.microsofttranslator.com'
		path = '/translate?api-version=3.0'

		# Translate to German.
		params = '&to=de'

		uri = URI (host + path + params)

		content = '[{"Text" : "' + text + '"}]'

		request = Net::HTTP::Post.new(uri)
		request['Content-type'] = 'application/json'
		request['Content-length'] = content.length
		request['Ocp-Apim-Subscription-Key'] = key
		request['X-ClientTraceId'] = SecureRandom.uuid
		request.body = content

		response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
		http.request (request)
		end

		result = response.body.force_encoding("utf-8")

		json = JSON.parse(result)
		
		begin
			return json[0]["translations"][0]["text"]
		rescue => exception
			return "Error translating text"
		end
	end

end
