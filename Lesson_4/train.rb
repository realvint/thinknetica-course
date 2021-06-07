# Поезда
class Train
  attr_reader :speed, :wagons

  def initialize(number, type, wagons)
    @number = number.to_s
    @type = type
    @speed = 0
    @wagons = wagons
  end

  def speed_up # Набирать скорость
    @speed += 20
  end

  def stop # Останавливаться (сбрасывать скорость до нуля)
    @speed = 0
  end

  def add_wagon # Прицепить вагон
    if speed.zero?
      @wagons += 1
    end
  end

  def delete_wagon # Отцепить вагон (проверки на нулевое и отрицательное количество вагонов нет в ТЗ )
    if speed.zero?
      @wagons -= 1
    end
  end

  def take_route(new_route) # Принять маршрут следования (инстанс Route)
    @route = new_route
    @station_index = 0
    # Берём у класса Route геттер route (список станций) и методом класса Station добавляем поезд к первой станции
    @route.route[@station_index].train_arrive(self)
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
end