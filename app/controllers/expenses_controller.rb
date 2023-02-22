require 'bigdecimal'
class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]
  before_action :authenticate_user!


  def index
    user = User.find_by(id: current_user.id)
    # @activities = PublicActivity::Activity.order(created_at: :desc)
    @user_expenses = user.expenses.includes(:group).where.not(group_id: nil).order(created_at: :desc)
    @total = @user_expenses.sum(:amount)
  end

  def new
    @expense = Expense.new
  end

  def edit; end

  def create
    @expense = Expense.new(expense_params)
    @user = User.find_by(id: current_user.id)
    # @expense.create_activity key: 'expense.created', owner: current_user, params: { name: @expense.name, amount: @expense.amount }
    @expense.user = current_user
    
    # @activity = PublicActivity::Activity.new
    # # set the owner of the activity
    # @activity.owner_id = current_user.id
    # # set the key and parameters of the activity
    # @activity.key = 'expense.created'
    # @activity.parameters = { name: @expense.name, amount: @expense.amount }
    # @expense.activities = [@activity]
    if @expense.save
      @expense.create_activity :create, owner: current_user, parameters: {amount: @expense.amount.to_s, user: User.find(current_user.id).email, temp_key: "Expense Created"} 
      @expense.profile_photo.attach(params[:profile_photo]) if params[:profile_photo]
      if @expense.group_id.nil?
        redirect_to home_external_path, notice: 'Expense created without group id.'
      else
        redirect_to expenses_path, notice: 'Expense was successfully created.'
      end
    else
      render :new
    end
  end

  def update
    if @expense.update(expense_params)
      @expense.profile_photo.attach(params[:expense][:profile_photo]) if params[:expense][:profile_photo]
      @expense.create_activity :create, owner: current_user, parameters: {amount: @expense.amount.to_s, user: User.find(current_user.id).email, temp_key: "Expense Updated"} 
      # Create an activity record to track the update of the expense
      # @expense.create_activity key: 'expense.updated', owner: current_user , params: { name: @expense.name, amount: @expense.amount }
      if @expense.group_id.nil?
        redirect_to home_external_path, notice: 'expense without group id was successfully updated.'
      else
        redirect_to expenses_path, notice: 'Expense was successfully updated.'
      end
    else
      render :edit
    end
  end


  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: 'Expense was successfully deleted.'
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:name, :amount, :group_id, :profile_photo)
  end  
  
end
