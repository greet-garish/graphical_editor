# frozen_string_literal: true

class GraphicalEditor
  def initialize(rows, cols)
    @image = Array.new(cols) { Array.new(rows, 'O') }
  end

  def run_command(command_with_args)
    command, *args = command_with_args.split(' ')

    case command
    when 'I'
      initialize(*args.map(&:to_i))
    when 'C'
      clear
    when 'L'
      color_pixel(*args)
    when 'V'
      draw_vertical(*args)
    when 'H'
      draw_horizontal(*args)
    when 'F'
      fill_region(*args)
    when 'S'
      puts display
    end

    self
  end

  def display
    @image.map(&:join).join("\n")
  end

  private

  def clear
    @image.map! { |row| row.fill('O') }
  end

  def color_pixel(x, y, color)
    x, y = x.to_i - 1, y.to_i - 1
    @image[y][x] = color
  end

  def draw_vertical(x, y1, y2, color)
    x, y1, y2 = x.to_i - 1, y1.to_i - 1, y2.to_i - 1
    y1, y2 = y2, y1 if y1 > y2
    (y1..y2).each { |y| @image[y][x] = color }
  end

  def draw_horizontal(x1, x2, y, color)
    x1, x2, y = x1.to_i - 1, x2.to_i - 1, y.to_i - 1
    x1, x2 = x2, x1 if x1 > x2
    (x1..x2).each { |x| @image[y][x] = color }
  end

  def fill_region(x, y, color)
    x, y = x.to_i - 1, y.to_i - 1
    old_color = @image[y][x]

    fill(x, y, old_color, color)
  end

  def fill(x, y, old_color, new_color)
    return if x < 0 || x >= @image[0].size || y < 0 || y >= @image.size
    return if @image[y][x] != old_color

    @image[y][x] = new_color

    fill(x + 1, y, old_color, new_color)
    fill(x - 1, y, old_color, new_color)
    fill(x, y + 1, old_color, new_color)
    fill(x, y - 1, old_color, new_color)
  end
end
