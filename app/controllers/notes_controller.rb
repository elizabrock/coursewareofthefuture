class NotesController < ApplicationController
  expose(:note, attributes: :note_params)

  before_filter :require_instructor!

  def create
    if note.save
      render :show
    else
      render :new
    end
  end

  def update
    if note.save
      render :show
    else
      render :edit
    end
  end


  private

  def note_params
    params.require(:note).permit(:content)
  end

end
