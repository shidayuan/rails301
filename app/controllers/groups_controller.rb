class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy, :jion, :quit]
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)

  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit

  end

  def update

    if @group.update(group_params)
      redirect_to groups_path
    else
    render :edit
  end
end

  def destroy

    @group.destroy
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入讨论组成功"
    else
      flash[:warning] = "已经是讨论组成员"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

   if current_user.is_member_of?(@group)
     current_user.quit!(@group)
     flash[:notice] = "退出讨论组成功"
   else
     flash[:warnig] = "不是讨论组还退出个屎"
   end
   redirect_to group_path(@group)
 end


  private

  def find_group_and_check_permission
     @group = Group.find(params[:id])

     if current_user != @group.user
       redirect_to root_path, alert: "You have no peimission"
     end
   end

  def group_params
    params.require(:group).permit(:title, :description)
  end

end
