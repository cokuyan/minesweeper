class Tile
  def initialize()
    @bomb = false
    @status = :hidden
    @neighbors = []
  end

  attr_accessor :status, :neighbors
  attr_writer :bomb

  def bomb?
    @bomb
  end

  def reveal
    return if flagged? || bomb?

    @status = :revealed

    neighbors.each do |neighbor|
      neighbor.reveal if neighbor_bomb_count.zero? && !neighbor.revealed?
    end

  end

  def revealed?
    @status == :revealed
  end

  def neighbor_bomb_count
    neighbors.select(&:bomb?).count
  end

  def flag
    if @status == :flagged
      @status = :hidden
    else
      @status = :flagged unless revealed?
    end
  end

  def flagged?
    @status == :flagged
  end

end
