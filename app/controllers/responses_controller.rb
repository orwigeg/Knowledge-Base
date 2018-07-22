class ResponsesController < ApplicationController
def create
	@post = Post.find(params[:post_id])
	@response = @post.responses.create(response_params)
	redirect_to post_path(@post)
end

def destroy
	@post = Post.find(params[:post_id])
	@response = @post.responses.find(params[:id])
	@response.destroy
	redirect_to post_path(@post)
end

private def response_params
	params.require(:response).permit(:username, :body)
end

end
