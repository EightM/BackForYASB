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
	|   ЗадачиПроцесса.Контролирующий									КАК Контролирующий,
	| 	ЗадачиПроцесса.ПлановаяДатаНачала								КАК ПлановаяДатаНачала,
	|   ЗадачиПроцесса.Предмет                                          КАК Предмет,
	|	ЗадачиПроцесса.Статус                                           КАК Статус,
	|	ЗадачиПроцессаПротоколВзаимодействия.Дата                       КАК ДатаСоздания,
	|	ЗадачиПроцесса.КрайняяДатаОкончания                             КАК КрайняяДатаОкончания,
	|	ЕСТЬNULL(TG_СоответствияСотрудниковID.ТелеграмId, """") 		КАК ТелеграмId,
	|	ВЫБОР
	|		КОГДА ЗадачиПроцесса.Предмет ССЫЛКА Справочник.ФункцииМеханизмов
	|			ТОГДА ЗадачиПроцесса.Предмет.Владелец.Владелец
	|		КОГДА ЗадачиПроцесса.Предмет ССЫЛКА Справочник.СборкиВерсии
	|			ТОГДА ЗадачиПроцесса.Предмет.Владелец.Владелец
	|		ИНАЧЕ ЗадачиПроцесса.Предмет.Владелец
	|	КОНЕЦ КАК Проект
	|ИЗ
	|	Справочник.ЗадачиПроцесса.ПротоколВзаимодействия КАК ЗадачиПроцессаПротоколВзаимодействия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиПроцесса КАК ЗадачиПроцесса
	|		ПО ЗадачиПроцессаПротоколВзаимодействия.Ссылка = ЗадачиПроцесса.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TG_ПерсональныеНастройкиУведомленийВTelegram КАК ПерсональныеНастройкиУведомленийПользователей
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
	|	И ПерсональныеНастройкиУведомленийПользователей.УведомлятьВTelegramОНаправленииЗадачИсполнителю
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
		
		РеквизитыЗадачи.Вставить("Наименование", ВыборкаЗадачи.Задача);
		РеквизитыЗадачи.Вставить("Код", ВыборкаЗадачи.Код);
		РеквизитыЗадачи.Вставить("Статус", ВыборкаЗадачи.Статус);
		РеквизитыЗадачи.Вставить("Автор", Справочники.Пользователи.ПустаяСсылка());
		РеквизитыЗадачи.Вставить("Исполнитель", ВыборкаЗадачи.Исполнитель);
		РеквизитыЗадачи.Вставить("Контролирующий", ВыборкаЗадачи.Контролирующий);
		РеквизитыЗадачи.Вставить("Начало", ВыборкаЗадачи.ПлановаяДатаНачала);
		РеквизитыЗадачи.Вставить("Окончание", ВыборкаЗадачи.КрайняяДатаОкончания);
		НавигационнаяСсылка = СгенерироватьНавигационнуюСсылку(ВыборкаЗадачи.Задача, ПараметрыРассылки);
		РеквизитыЗадачи.Вставить("Описание", "");
		РеквизитыЗадачи.Вставить("Предмет", ВыборкаЗадачи.Предмет);
		РеквизитыЗадачи.Вставить("Проект", ВыборкаЗадачи.Проект);
		РеквизитыЗадачи.Вставить("СсылкаНаЗадачу", НавигационнаяСсылка);
		РеквизитыЗадачи.Вставить("ТелеграмId", "");
		
		ОписаниеЗадачи = ВыборкаЗадачи.Описание.Получить();
		Если ТипЗнч(ОписаниеЗадачи) = Тип("ФорматированныйДокумент") Тогда
			РеквизитыЗадачи.Описание = ОписаниеЗадачи.ПолучитьТекст();
		КонецЕсли;
				
		ВыборкаДетали = ВыборкаЗадачи.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			
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

Процедура ОтправитьУведомленияПоНаправленнымОшибкам(ДатаПоследнейРассылки, МассивПроектов, ПараметрыРассылки)

	Запрос = Новый Запрос;
	Запрос.Текст =	
	"ВЫБРАТЬ
	|	ОшибкиПротокол.Дата КАК ДатаНаправленияИсполнителю,
	|	ОшибкиПротокол.Ссылка КАК Ошибка,
	|	ОшибкиПротокол.Ссылка.Владелец.НаименованиеКонфигурации КАК НаименованиеКонфигурации,
	|	ОшибкиПротокол.Ссылка.Владелец.КраткоеНаименованиеКонфигурации КАК КраткоеНаименованиеКонфигурации,
	|	ОшибкиПротокол.КомуНаправлена КАК КомуНаправлена,
	|	ОшибкиПротокол.Комментарий КАК Комментарий,
	|	ОшибкиПротокол.Ссылка.Код КАК Код,
	|	ОшибкиПротокол.Ссылка.Наименование КАК Наименование,
	|	ОшибкиПротокол.Ссылка.Владелец КАК Проект,
	|	ОшибкиПротокол.Ссылка.Статус КАК Статус,
	|	ОшибкиПротокол.Ссылка.ПорядокВоспроизведения КАК ПорядокВоспроизведения,
	|	ОшибкиПротокол.Ссылка.СрочностьИсправления КАК СрочностьИсправления,
	|	Пользователи.АдресЭлектроннойПочты КАК АдресИсполнителя,
	| 	TG_СоответствияСотрудниковID.ТелеграмId КАК ТелеграмId
	|ИЗ
	|	Справочник.Ошибки.Протокол КАК ОшибкиПротокол
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			КонтактыПользователей.Ссылка КАК Пользователь,
	|			КонтактыПользователей.АдресЭП КАК АдресЭлектроннойПочты
	|		ИЗ
	|			Справочник.Пользователи.КонтактнаяИнформация КАК КонтактыПользователей
	|		ГДЕ
	|			КонтактыПользователей.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя)
	|			И КонтактыПользователей.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|			И НЕ КонтактыПользователей.АдресЭП ПОДОБНО """") КАК Пользователи
	|		ПО ОшибкиПротокол.КомуНаправлена = Пользователи.Пользователь
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.TG_ПерсональныеНастройкиУведомленийВTelegram КАК ПерсональныеНастройкиУведомленийПользователей
	|		ПО ОшибкиПротокол.КомуНаправлена = ПерсональныеНастройкиУведомленийПользователей.Пользователь И ПерсональныеНастройкиУведомленийПользователей.УведомлятьВTelegramОНаправленииОшибки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TG_СоответствияСотрудниковID КАК TG_СоответствияСотрудниковID
	|		ПО (ОшибкиПротокол.КомуНаправлена = TG_СоответствияСотрудниковID.Сотрудник)
	|ГДЕ
	|	ОшибкиПротокол.Ссылка.Владелец В(&МассивПроектов)
	|	И НЕ ОшибкиПротокол.Ссылка.ПометкаУдаления
	|	И ОшибкиПротокол.НомерСтроки = 1
	|	И ОшибкиПротокол.Дата > &ДатаПоследнейРассылки
	|	И ОшибкиПротокол.Дата <= &ВерхняяГраницаПоДате
	|	И НЕ ОшибкиПротокол.КомуНаправлена.ПометкаУдаления
	|	И НЕ ОшибкиПротокол.КомуНаправлена.Недействителен
	|	И ПерсональныеНастройкиУведомленийПользователей.УведомлятьОНаправленииОшибокИсполнителю
	|	И НЕ ОшибкиПротокол.Ссылка.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОшибок.ПроверенаИсправлена), ЗНАЧЕНИЕ(Перечисление.СтатусыОшибок.Отозвана))
	|	И ОшибкиПротокол.КомуНаправлена <> ОшибкиПротокол.Автор"
	;
	
	Запрос.УстановитьПараметр("ДатаПоследнейРассылки", ПараметрыРассылки.ДатаПоследнейРассылки);
	Запрос.УстановитьПараметр("ВерхняяГраницаПоДате", ПараметрыРассылки.ВерхняяГраницаПоДате);
	Запрос.УстановитьПараметр("МассивПроектов", МассивПроектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
							
		РеквизитыОшибки = Новый Структура();
		
		РеквизитыОшибки.Вставить("Ошибка", Выборка.Ошибка);
		РеквизитыОшибки.Вставить("Статус", Выборка.Статус);
		РеквизитыОшибки.Вставить("СрочностьИсправления", Выборка.СрочностьИсправления);
		РеквизитыОшибки.Вставить("КомуНаправлена", Выборка.КомуНаправлена);
		РеквизитыОшибки.Вставить("Комментарий", Выборка.Комментарий);
		РеквизитыОшибки.Вставить("Код", Выборка.Код);
		РеквизитыОшибки.Вставить("Наименование", Выборка.Наименование);
		РеквизитыОшибки.Вставить("ПорядокВоспроизведения", Выборка.ПорядокВоспроизведения);
		РеквизитыОшибки.Вставить("ТелеграмId", Выборка.ТелеграмId);
		
		Если НЕ ПустаяСтрока(РеквизитыОшибки.ТелеграмId) Тогда
			ОтправитьОшибки(РеквизитыОшибки);
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
	
	ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.ЗадачаПроцесса;
	НастройкиПользователя = НастройкиСоставаПользователей(РеквизитыЗадачи.Исполнитель, ТипОбъекта);
	Если НастройкиПользователя = Неопределено Тогда
		НастройкиПользователя = СформироватьСтандартныеНастройки(ТипОбъекта);
	КонецЕсли; 
	
	Данные = Новый Структура;
	Если НастройкиПользователя.Свойство("Наименование") <> Ложь Тогда
		Данные.Вставить("name", Строка(РеквизитыЗадачи.Наименование));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Код") <> Ложь Тогда
		Данные.Вставить("code", Строка(РеквизитыЗадачи.Код));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Статус") <> Ложь Тогда
		Данные.Вставить("status", Строка(РеквизитыЗадачи.Статус));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Автор") <> Ложь Тогда
		Данные.Вставить("author", Строка(РеквизитыЗадачи.Автор));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Исполнитель") <> Ложь Тогда
		Данные.Вставить("executor", Строка(РеквизитыЗадачи.Исполнитель));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Контролирующий") <> Ложь Тогда
		Данные.Вставить("controller", Строка(РеквизитыЗадачи.Контролирующий));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Начало") <> Ложь Тогда
		ДатаНачала = ?(НЕ ЗначениеЗаполнено(РеквизитыЗадачи.Начало),
		"", Строка(РеквизитыЗадачи.Начало));
		Данные.Вставить("begin_date", ДатаНачала);
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Окончание") <> Ложь Тогда
		ДатаОкончания = ?(НЕ ЗначениеЗаполнено(РеквизитыЗадачи.Окончание),
		"", Строка(РеквизитыЗадачи.Окончание));
		Данные.Вставить("end_date", ДатаОкончания);
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Предмет") <> Ложь Тогда
		Данные.Вставить("subject", Строка(РеквизитыЗадачи.Предмет));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Проект") <> Ложь Тогда
		Данные.Вставить("project", Строка(РеквизитыЗадачи.Проект));
	КонецЕсли;
	
	Если НастройкиПользователя.Свойство("Описание") <> Ложь Тогда	
		Данные.Вставить("text", РеквизитыЗадачи.Описание);
	КонецЕсли;

	Данные.Вставить("external_ref", РеквизитыЗадачи.СсылкаНаЗадачу);
	Данные.Вставить("recipient_id", РеквизитыЗадачи.ТелеграмId);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ФайлТелаЗапроса = ПолучитьИмяВременногоФайла("json");
	ЗаписьJSON.ОткрытьФайл(ФайлТелаЗапроса);
	ЗаписатьJSON(ЗаписьJSON, Данные, Новый НастройкиСериализацииJSON);
	СтрокаJSON = ЗаписьJSON.Закрыть();
		
	Попытка
		ssl = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
		 HTTPСоединение = Новый HTTPСоединение(ДанныеОсновногоБота.АдресРазмещения,
		// ДанныеОсновногоБота.Порт, , , , 40, ssl);
		ДанныеОсновногоБота.Порт, , , , 40);
		Запрос = Новый HTTPЗапрос("/messages/task");
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

Процедура ОтправитьОшибки(РеквизитыОшибки)
	
	ДанныеОсновногоБота = ОсновнойТелеграмБот();
	
	Если ДанныеОсновногоБота = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщения в telegram'"),
		УровеньЖурналаРегистрации.Ошибка,,,
		"Не найден бот по умолчанию"); 
		
		Возврат;
		
	КонецЕсли;
	
	ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.Ошибка;
	НастройкиПользователя = НастройкиСоставаПользователей(РеквизитыОшибки.КомуНаправлена, ТипОбъекта);
	Если НастройкиПользователя = Неопределено Тогда
		НастройкиПользователя = СформироватьСтандартныеНастройки(ТипОбъекта);
	КонецЕсли;
	
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

Функция СгенерироватьНавигационнуюСсылку(Задача, ПараметрыРассылки)
		
	Если ЗначениеЗаполнено(Параметрырассылки.АдресИБВИнтернет) Тогда
		// Выводится внешняя ссылка
		Возврат НавигационнаяСсылкаДляУведомления(Задача, ПараметрыРассылки.АдресИБВИнтернет, Истина);
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция НавигационнаяСсылкаДляУведомления(Ссылка, АдресПубликацииИБ, ВебПубликация=Ложь)
	
	АдресПубликацииИБ = СОКРЛП(АдресПубликацииИБ);
	
	Если ВебПубликация И Прав(АдресПубликацииИБ,1)<> "/" Тогда
		АдресПубликацииИБ = АдресПубликацииИБ + "/";
	КонецЕсли;
		
	Возврат АдресПубликацииИБ + "#" + ПолучитьНавигационнуюСсылку(Ссылка);
	
КонецФункции 

Функция НастройкиСоставаПользователей(Исполнитель, ТипОбъекта)
	
	Если ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.ЗадачаПроцесса Тогда
		Возврат ПолучитьНастройкиПоЗадачам(Исполнитель);
	ИначеЕсли ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.Ошибка Тогда 
		Возврат ПолучитьНастройкиПоОшибкам(Исполнитель);
	КонецЕсли; 
	
КонецФункции

Функция ПолучитьНастройкиПоЗадачам(Исполнитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.РеквизитОбъекта КАК РеквизитОбъекта,
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.ВкючатьВСостав КАК ВкючатьВСостав
	|ИЗ
	|	РегистрСведений.TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса КАК TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса
	|ГДЕ
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоЗадачамПроцесса.Сотрудник = &Сотрудник";
	
	Запрос.УстановитьПараметр("Сотрудник", Исполнитель);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	НастройкиСостава = Новый Структура;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НастройкиСостава.Вставить(Строка(Выборка.РеквизитОбъекта), Выборка.ВкючатьВСостав);	
	КонецЦикла; 
	
	Возврат НастройкиСостава;
	
КонецФункции

Функция ПолучитьНастройкиПоОшибкам(Исполнитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоОшибкам.РеквизитОбъекта КАК РеквизитОбъекта,
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоОшибкам.ВключатьВСостав КАК ВключатьВСостав
	|ИЗ
	|	РегистрСведений.TG_ПерсональныеНастройкиСоставаУведомленийПоОшибкам КАК TG_ПерсональныеНастройкиСоставаУведомленийПоОшибкам
	|ГДЕ
	|	TG_ПерсональныеНастройкиСоставаУведомленийПоОшибкам.Сотрудник = &Сотрудник";
	
	Запрос.УстановитьПараметр("Сотрудник", Исполнитель);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	НастройкиСостава = Новый Структура;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НастройкиСостава.Вставить(Строка(Выборка.РеквизитОбъекта), Выборка.ВкючатьВСостав);	
	КонецЦикла; 
	
	Возврат НастройкиСостава;
		
КонецФункции
 
Функция СформироватьСтандартныеНастройки(ТипОбъекта)
	
	Если ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.ЗадачаПроцесса Тогда
		Возврат ПолучитьСтандартныйСоставПоЗадачам();
	ИначеЕсли ТипОбъекта = Перечисления.TG_ОбъектыДляНастройкиСоставаОповещений.Ошибка Тогда
		Возврат ПолучитьСтандартныйСоставПоОшибкам();
	КонецЕсли; 
	
КонецФункции

Функция ПолучитьСтандартныйСоставПоЗадачам()
	
	НастройкиПоУмолчанию = Новый Структура;
	НастройкиПоУмолчанию.Вставить("Наименование", Истина);
	НастройкиПоУмолчанию.Вставить("Код", Истина);
	НастройкиПоУмолчанию.Вставить("Описание", Истина);
	
	Возврат НастройкиПоУмолчанию;
	
КонецФункции 

Функция ПолучитьСтандартныйСоставПоОшибкам()
	
	НастройкиПоУмолчанию = Новый Структура;
	НастройкиПоУмолчанию.Вставить("Наименование", Истина);
	НастройкиПоУмолчанию.Вставить("Код", Истина);
	НастройкиПоУмолчанию.Вставить("ПорядокВоспроизведения", Истина);
	
	Возврат НастройкиПоУмолчанию;

	
КонецФункции
 
  
#КонецОбласти