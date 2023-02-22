class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # def equal_split
  #   group = Group.find(params[:id])
  #   expenses = group.expenses.all
  #   num_people = group.users.count
  #   total_amount = expenses.sum(:amount)
  #   per_person = total_amount / num_people
  #   puts per_person
  #   group.users.each do |user|
  #     user_amount = expenses.where(user_id: user.id).sum(:amount)
  #     user.update(balance: user.balance + per_person - user_amount)
  #     puts user_amount
  #   end
  #   redirect_to group_path(group), notice: 'Bills were split equally.'
  # end

  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    group = Group.find(params[:id])
    @group_expenses = group.expenses.all.order(created_at: :desc)
    @total = @group_expenses.sum(:amount)
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)
    @group.user_id = current_user.id
    if @group.save
      @group.icon.attach(params[:group][:icon]) if params[:group][:icon]
      @group.create_activity :create, owner: current_user, parameters: {user: User.find(current_user.id).email, temp_key: "Group Created", name: @group.name} 
      redirect_to groups_path, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      @group.create_activity :create, owner: current_user, parameters: {user: User.find(current_user.id).email, temp_key: "Group Updated"} 
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.create_activity :create, owner: current_user, parameters: {user: User.find(current_user.id).email, temp_key: "Group Destroyed"} 
    @group.destroy
    params[:id] = nil
    flash[:notice] = "Group has been deleted"
    redirect_to groups_url, notice: 'Group was successfully deleted.'
  end


  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :icon)
  end

  def search
    search_query = params[:q]
    @groups = Group.where("name LIKE ?", "%#{search_query}%")
  end
  
  def split_group_expenses
    amount = params[:amount].to_f
    split_type = params[:split_type]
    @group = Group.find(params[:id])
    @group_expenses = @group.expenses

    case split_type
    when 'Equal'
      # Split expenses equally
      @per_person_share = amount / (@group_expenses.count)
      @group_expenses.each do |member|
        member.update(amount: @per_person_share + member.amount)
      end
    when 'Unequal'
      # Split expenses unequally
      split_percentages = params[:unequal_splits].split(',').map(&:to_f)
      total_percentages = split_percentages.sum
      if total_percentages != 100
        # Handle error: percentages should add up to 100
      else
        # Calculate split amounts
        @split_amounts = split_percentages.map { |p| amount * p / 100 }
        @group_expenses.each_with_index do |member, index|
          member.update(amount: member.amount + @split_amounts[index])
        end
    end
end

    redirect_to group_path(@group), notice: 'Expenses split successfully!'
  end

end
