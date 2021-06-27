require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :speed, :wagons, :number, :type

  NUMBER_FORMAT = /^\w{3}[-]*\w{2}$/
  TYPE_FORMAT = /^(passenger|cargo)$/

  @@trains = []

  def initialize(number, type)
    register_instance
    @type = type
    @number = number
    validate!
    @speed = 0
    @wagons = []
    @@trains << self
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def self.find(number)
    @@trains.select { |train| train.number == number }
  end

  def speed_up # Набирать скорость
    @speed += 20
  end

  def stop # Останавливаться (сбрасывать скорость до нуля)
    @speed = 0
  end

  def add_wagon(wagon) # Прицепить вагон
    if speed.zero?
      @wagons << wagon
    end
  end

  def delete_wagon
    if speed.zero?
      @wagons.pop
    end
  end

  def wagons_each(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end

  def take_route(route) # Принять маршрут следования
    @route = route
    @station_index = 0
    @route.route[@station_index].train_arrive(self)
  end

  def go_next_station # Переместить поезд вперёд на одну станцию
    if show_next_station # Проверяем есть ли следующая станция
      @route.route[@station_index].train_depart(self) # Отправить с текущей станции
      @station_index += 1
      @route.route[@station_index].train_arrive(self) # Принять на следующей станции
    end
  end

  def go_prev_station # Переместить поезд назад на одну станцию
    if show_prev_station # Проверяем есть ли предыдущая станция
      @route.route[@station_index].train_depart(self) # Отправить с текущей станции
      @station_index -= 1
      @route.route[@station_index].train_arrive(self) # Принять на предыдущей станции
    end
  end

  private # Эти методы используются только внутри класса Train

  def validate!
    raise StandardError, 'Ошибка! Введите номер поезда в следующем формате: три буквы/три цифры, необязательный дефис и две буквы/две цифры' if number !~ NUMBER_FORMAT
    raise StandardError, 'Ошибка! Введите тип поезда в следующем формате: пассажирский - [passenger], грузовой - [cargo]' if type !~ TYPE_FORMAT
  end
  def current_station # Возвращает текущую станцию, на которой стоит поезд
    @route.route[@station_index]
  end

  def show_next_station
    @route.route[@station_index + 1]
  end

  def show_prev_station
    @route.route[@station_index -1]
  end
end