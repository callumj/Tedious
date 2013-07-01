class ReviewsController < ApplicationController

  def index
    @review_count = Review.pending_scope.count
  end

  def handle_approve_action
    handle_action :approve
  end

  def handle_reject_action
    handle_action :reject
  end

  def edit
    @review = Review.find(params[:id])
    @review.lock!
  end

  def update
    @review = Review.find(params[:id])
    if (handle_operation(params[:operation].try(:to_sym)))
      next_pending_for_edit
    else
      render :edit
    end
  end

  def next_pending_for_edit
    @next_review = Review.pending_scope.first
    if @next_review
      redirect_to edit_review_path(@next_review)
    else
      redirect_to action: :index
    end
  end

  def next_pending_for_bookmarklet
    @next_review = Review.pending_scope.first
    if @next_review
      @next_review.lock!
      session[:last_review_id] = @next_review.id
      render :redirecting
    else
      redirect_to action: :index
    end
  end

  private

    def handle_action(mode)
      if (review_id = session[:last_review_id])
        @review = Review.find review_id
        if (handle_operation(mode))
          next_pending_for_bookmarklet
        else
          render :edit
        end
      else
        render :index
      end
    end

    def handle_operation(mode)
      case mode
      when :approve
        @review.accept!
        true
      when :reject
        @review.reject!
        true
      else
        flash[:error] = "Operation must be specified"
        false
      end
    end

end
