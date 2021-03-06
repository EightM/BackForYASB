﻿
Функция РегистрацияСотрудникаРегистрацияIDСотрудника(Запрос)
		
	Сообщение = Запрос.ПолучитьТелоКакСтроку("UTF-8");
	
	Если ПустаяСтрока(Сообщение) Тогда
		
		Ответ = Новый HTTPСервисОтвет(400);
		Возврат Ответ;
		
	КонецЕсли; 
	
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку(Сообщение); 
	ПриглашениеJSON = ПрочитатьJSON(ЧтениеJSON); 
	ЧтениеJSON.Закрыть();
	
	IdПриглашения = Неопределено;
	ТелеграмId = Неопределено;
	
	ПриглашениеJSON.Свойство("user_id", ТелеграмId);
	ПриглашениеJSON.Свойство("invite_id", IdПриглашения);
	
	Возврат ОбработатьДанныеЗапроса(ТелеграмId, IdПриглашения); 
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

Функция ПриглашениеСуществует(IDПриглашения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_Приглашения.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрСведений.TG_Приглашения КАК TG_Приглашения
	|ГДЕ
	|	TG_Приглашения.IDПриглашения = &IDПриглашения";
	
	Запрос.УстановитьПараметр("IDПриглашения", Новый УникальныйИдентификатор(IDПриглашения));
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Сотрудник;
	
КонецФункции

Процедура ЗаписатьНовоеСоответствие(Сотрудник, ТелеграмId)
	
	НаборЗаписей = РегистрыСведений.TG_СоответствияСотрудниковID.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сотрудник.Значение = Сотрудник;
	НаборЗаписей.Отбор.Сотрудник.Использование = Истина;
	НоваяЗапись = НаборЗаписей.Добавить();
	
	НоваяЗапись.Сотрудник = Сотрудник;
	НоваяЗапись.ТелеграмId = ТелеграмId; 
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура УдалитьПриглашение(Сотрудник, IdПриглашения)
	
	НаборЗаписей = РегистрыСведений.TG_Приглашения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сотрудник.Значение = Сотрудник;
	НаборЗаписей.Отбор.Сотрудник.Использование = Истина;

	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ОбработатьДанныеЗапроса(ТелеграмId, IdПриглашения)
	
	Если ТелеграмId <> Неопределено 
		И IdПриглашения <> Неопределено Тогда
		
		ПриглашенныйСотрудник = ПриглашениеСуществует(IdПриглашения);
		Если ПриглашенныйСотрудник.Пустая() Тогда
			
			Ответ = Новый HTTPСервисОтвет(400);
			Возврат Ответ;
			
		КонецЕсли; 
		
		Попытка
			ЗаписатьНовоеСоответствие(ПриглашенныйСотрудник, ТелеграмId);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Сохранение нового соответствия телеграм'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Ответ = Новый HTTPСервисОтвет(500);
			Возврат Ответ;
			
		КонецПопытки;
		
		Попытка
			УдалитьПриглашение(ПриглашенныйСотрудник, IdПриглашения);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление приглашения'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Ответ = Новый HTTPСервисОтвет(500);
			Возврат Ответ;
			
		КонецПопытки;
		
		Ответ = Новый HTTPСервисОтвет(200);
		Возврат Ответ;
		
	Иначе
		
		Ответ = Новый HTTPСервисОтвет(400);
		Возврат Ответ;
		
	КонецЕсли;
	
	
КонецФункции
 
 
#КонецОбласти
