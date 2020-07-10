﻿
#Область ОбработчикиСобытийФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	ТипОбъектаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТипОбъектаПриИзмененииНаСервере()
	СоставОповещений.Очистить();
	Если ЭтотОбъект.ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.ЗадачаПроцесса Тогда
		ЗаполнитьСоставОповещенийДляЗадачПроцесса();
	КонецЕсли; 	
КонецПроцедуры
 
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставОповещений
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСоставОповещенийДляЗадачПроцесса()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_СоставОсновныхПолейЗадачиПроцесса.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ РеквизитыЗадачи
	|ИЗ
	|	Перечисление.TG_СоставОсновныхПолейЗадачиПроцесса КАК TG_СоставОсновныхПолейЗадачиПроцесса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыЗадачи.Ссылка КАК ИмяРеквизита,
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.ВкючатьВСостав КАК ВключатьВСостав
	|ИЗ
	|	РеквизитыЗадачи КАК РеквизитыЗадачи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса КАК TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса
	|		ПО РеквизитыЗадачи.Ссылка = TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.РеквизитОбъекта
	|			И (TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.Сотрудник = &Сотрудник)";
	
	
	Запрос.УстановитьПараметр("Сотрудник", Пользователи.ТекущийПользователь());
	ЭтотОбъект.СоставОповещений.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	НаборЗаписей = РегистрыСведений.TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сотрудник.Значение = ТекущийПользователь;
	НаборЗаписей.Отбор.Сотрудник.Использование = Истина;
	
	Для каждого Строка Из СоставОповещений Цикл
		Если Строка.ВключатьВСостав = Истина Тогда
			НоваяСтрока = НаборЗаписей.Добавить();
			НоваяСтрока.Сотрудник = ТекущийПользователь;
			НоваяСтрока.РеквизитОбъекта = Строка.ИмяРеквизита;
			НоваяСтрока.ВкючатьВСостав = Строка.ВключатьВСостав;
		КонецЕсли; 
	КонецЦикла; 
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Запись персональных настроек'"),
		УровеньЖурналаРегистрации.Ошибка,,,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Попытка
		СохранитьНаСервере();
	Исключение
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоказатьПредупреждение(,НСтр("ru = 'Операция не может быть выполнена по причине:'") + Символы.ПС + ТекстСообщения);
	КонецПопытки; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Попытка
		СохранитьНаСервере();
	Исключение
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоказатьПредупреждение(,НСтр("ru = 'Операция не может быть выполнена по причине:'") + Символы.ПС + ТекстСообщения);
		Возврат;
	КонецПопытки; 	
	Закрыть();
КонецПроцедуры
 
#КонецОбласти