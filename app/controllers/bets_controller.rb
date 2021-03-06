class BetsController < ApplicationController
  before_filter :require_user,:only=>[:new,:create,:bet]
  def index
    @bets=Bet.all
  end

  def show
    @bet=Bet.find_by_id params[:id]
    @comments=Comment.find_all_by_bet_id params[:id]
  end

  #find bets by categories
  def list
    @bet=Bet.find_all_by_cat params['cat'] 
  end
  
  #create new bet
  def new
    @bet=Bet.new
  end

  def create
    @bet = Bet.new params[:bet] 
    @user = current_user.id
    @bet.user_id=@user
    if @bet.save
      @bet.deal_history=DealHistory.new :bet_id=>@bet.reload.id,:expire=>@bet.expire,:result=>"betting"
      @bet.deal_history.save
      redirect_to :action=>:index,:controller=>:bets
    else
      puts @bet.errors.full_messages
    end
  end
end
