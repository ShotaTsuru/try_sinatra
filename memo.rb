class Memo
  def index
    @memos = Memo.find
  end

  def edit
    @memo = Memo.find
  end

  def new
    @memo = Memo.new
  end

  def create
    
  end  
end

class Data
  def find
  end

  def edit
  end


end