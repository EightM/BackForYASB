﻿
#Область ПрограммныйИнтерфейс

Процедура ОтправитьУведомленияПоЗадачамПроцесса(ДатаПоследнейРассылки, МассивПроектов, ПараметрыРассылки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	ЗадачиПроцесса.Ссылка                                           КАК Задача,
	|	ЗадачиПроцесса.Предмет.Наименование                             КАК НаименованиеВладельца,
	|	ЗадачиПроцесса.Предмет.Владелец.НаименованиеКонфигурации        КАК НаименованиеКонфигурации,
	|	ЗадачиПроцесса.Предмет.Владелец.КраткоеНаименованиеКонфигурации КАК КраткоеНаименованиеКонфигурации,
	|	ЗадачиПроцесса.Код                                              КАК Код,
	|	ЗадачиПроцесса.Описание                                         КАК Описание,
	|	ЗадачиПроцесса.Наименование                                     КАК Наименование,
	|	ЗадачиПроцессаПротоколВзаимодействия.Автор                      КАК Автор,
	|	ЗадачиПроцесса.Исполнитель                                      КАК Исполнитель,
	|	ЗадачиПроцесса.Статус                                           КАК Статус,
	|	ЗадачиПроцессаПротоколВзаимодействия.Дата                       КАК ДатаСоздания,
	|	ЗадачиПроцесса.КрайняяДатаОкончания                             КАК КрайняяДатаОкончания,
	|	ЕСТЬNULL(TG_СоответствияСотрудниковID.ТелеграмId, """") 		КАК ТелеграмId
	|ИЗ
	|	Справочник.ЗадачиПроцесса.ПротоколВзаимодействия КАК ЗадачиПроцессаПротоколВзаимодействия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ПО ЗадачиПроцессаПротоколВзаимодействия.Ссылка = ЗадачиПроцесса.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПерсональныеНастройкиУведомленийПользователей КАК ПерсональныеНастройкиУведомленийПользователей
	|		ПО (ЗадачиПроцесса.Исполнитель = ПерсональныеНастройкиУведомленийПользователей.Пользователь)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО (ЗадачиПроцесса.Исполнитель = Пользователи.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TG_СоответствияСотрудниковID КАК TG_СоответствияСотрудниковID
	|		ПО (ЗадачиПроцесса.Исполнитель = TG_СоответствияСотрудниковID.Сотрудник)
	|ГДЕ
	|	ЗадачиПроцессаПротоколВзаимодействия.НомерСтроки = 1
	|	И ЗадачиПроцесса.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗадачПроцессов.Запланирована)
	|	И НЕ ЗадачиПроцесса.ПометкаУдаления
	|	И ЗадачиПроцесса.Исполнитель <> ЗадачиПроцессаПротоколВзаимодействия.Автор
	|	И ПерсональныеНастройкиУведомленийПользователей.УведомлятьОНаправленииЗадачИсполнителю
	|	И НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И ЗадачиПроцессаПротоколВзаимодействия.Дата > &ДатаПоследнейРассылки
	|	И ЗадачиПроцессаПротоколВзаимодействия.Дата <= &ВерхняяГраницаПоДате
	|	И ЗадачиПроцесса.Предмет.Владелец В(&МассивПроектов)
	|	И ЗадачиПроцесса.ЗадачаШаблона = ЗНАЧЕНИЕ(Справочник.ЗадачиШаблонаПроцесса.ПустаяСсылка)
	|ИТОГИ ПО
	|	Задача";
	
	Запрос.УстановитьПараметр("ДатаПоследнейРассылки", ПараметрыРассылки.ДатаПоследнейРассылки);
	Запрос.УстановитьПараметр("ВерхняяГраницаПоДате", ПараметрыРассылки.ВерхняяГраницаПоДате);
	Запрос.УстановитьПараметр("МассивПроектов", МассивПроектов);
	
	ВыборкаЗадачи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаЗадачи.Следующий() Цикл
			
		РеквизитыЗадачи = Новый Структура;
		
		РеквизитыЗадачи.Вставить("Задача", ВыборкаЗадачи.Задача);
		РеквизитыЗадачи.Вставить("Статус", ВыборкаЗадачи.Статус);
		РеквизитыЗадачи.Вставить("Автор", Справочники.Пользователи.ПустаяСсылка());
		РеквизитыЗадачи.Вставить("Исполнитель", ВыборкаЗадачи.Исполнитель);
		РеквизитыЗадачи.Вставить("ДатаСоздания",  Дата(1,1,1));
		РеквизитыЗадачи.Вставить("КрайняяДатаОкончания", ВыборкаЗадачи.КрайняяДатаОкончания);
		РеквизитыЗадачи.Вставить("ОписаниеЗадачи", "");
		РеквизитыЗадачи.Вставить("ТелеграмId", "");
		
		ОписаниеЗадачи = ВыборкаЗадачи.Описание.Получить();
		Если ТипЗнч(ОписаниеЗадачи) = Тип("ФорматированныйДокумент") Тогда
			РеквизитыЗадачи.ОписаниеЗадачи = ОписаниеЗадачи.ПолучитьТекст();
		КонецЕсли;
				
		ВыборкаДетали = ВыборкаЗадачи.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			
			РеквизитыЗадачи.ДатаСоздания = ВыборкаДетали.ДатаСоздания;
			РеквизитыЗадачи.Автор        =  ВыборкаДетали.Автор;
			РеквизитыЗадачи.ТелеграмId = ВыборкаДетали.ТелеграмId;
						
		КонецЦикла;
		
		Если НЕ ПустаяСтрока(РеквизитыЗадачи.ТелеграмId) Тогда
			ОтправитьСообщения(РеквизитыЗадачи);
			ДатаПоследнейРассылки = ТекущаяДатаСеанса();
		КонецЕсли; 
				
	КонецЦикла;
	
	Если ДатаПоследнейРассылки > Константы.ДатаПоследнейРассылки.Получить() Тогда
		Константы.ДатаПоследнейРассылки.Установить(ДатаПоследнейРассылки);
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтправитьСообщения(РеквизитыЗадачи)
	
	ДанныеОсновногоБота = ОсновнойТелеграмБот();
	
	Если ДанныеОсновногоБота = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщения в telegram'"),
		УровеньЖурналаРегистрации.Ошибка,,,
		"Не найден бот по умолчанию"); 
		
		Возврат;
		
	КонецЕсли; 
	
	Данные = Новый Структура;
	Данные.Вставить("name", Строка(РеквизитыЗадачи.Задача));
	Данные.Вставить("status", Строка(РеквизитыЗадачи.Статус));
	Данные.Вставить("author", Строка(РеквизитыЗадачи.Автор));
	Данные.Вставить("end_date", Строка(РеквизитыЗадачи.КрайняяДатаОкончания));
	Данные.Вставить("text", РеквизитыЗадачи.ОписаниеЗадачи);
	Данные.Вставить("recipient_id", РеквизитыЗадачи.ТелеграмId);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ФайлТелаЗапроса = ПолучитьИмяВременногоФайла("json");
	ЗаписьJSON.ОткрытьФайл(ФайлТелаЗапроса);
	ЗаписатьJSON(ЗаписьJSON, Данные, Новый НастройкиСериализацииJSON);
	СтрокаJSON = ЗаписьJSON.Закрыть();
		
	Попытка
		ssl = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
		HTTPСоединение = Новый HTTPСоединение(ДанныеОсновногоБота.АдресРазмещения,
		ДанныеОсновногоБота.Порт, , , , 40, ssl);
		Запрос = Новый HTTPЗапрос("/tasks");
		Запрос.Заголовки.Вставить("content-type", "application/json");
		Запрос.УстановитьИмяФайлаТела(ФайлТелаЗапроса);
		HTTPОтвет = HTTPСоединение.ОтправитьДляОбработки(Запрос);     
		Сообщить(HTTPОтвет.КодСостояния);
		
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщения в telegram'"),
		УровеньЖурналаРегистрации.Ошибка,,,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())); 
	КонецПопытки;
		
КонецПроцедуры

Функция ОсновнойТелеграмБот()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_Боты.Порт КАК Порт,
	|	TG_Боты.АдресРазмещения КАК АдресРазмещения
	|ИЗ
	|	Справочник.TG_Боты КАК TG_Боты
	|ГДЕ
	|	TG_Боты.Основной = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Результат = Новый Структура;
	Результат.Вставить("АдресРазмещения", Выборка.АдресРазмещения);
	Результат.Вставить("Порт", Выборка.Порт);
	
	Возврат Результат;
КонецФункции
 
#КонецОбласти