﻿
&НаСервере
&Вместо("ЗаписатьНастройкиУведомлений")
Процедура TG_ЗаписатьНастройкиУведомлений()
	
// Обработка настроек уведомлений о ходе выполнения технических проектов
	ЕстьИзменения = Ложь;
	
	Для Каждого СтрокаТаблицаНастроек из НастройкиУведомлений Цикл
		
		СтруктураПоиска = Новый Структура("Проект", СтрокаТаблицаНастроек.Проект);
		МассивСтрок = ИмеющиесяНастройки.НайтиСтроки(СтруктураПоиска);
		
		Если МассивСтрок.Количество()=0 Тогда
			ЕстьИзменения = Истина;
			Прервать;
		Иначе
			СтрокаНастроек = МассивСтрок[0];
			
			Если СтрокаТаблицаНастроек.УведомлятьОХодеВыполненияТехническихПроектов <> СтрокаНастроек.УведомлятьОХодеВыполненияТехническихПроектов
				ИЛИ СтрокаТаблицаНастроек.УведомлятьОбИзмененииСтатусовТехническихПроектов <> СтрокаНастроек.УведомлятьОбИзмененииСтатусовТехническихПроектов Тогда
				ЕстьИзменения = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьИзменения Тогда
		
		НаборЗаписей = РегистрыСведений.НастройкиУведомленийПользователей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(АвторизованныйПользователь, Истина);
		
		Для Каждого СтрокаНастроек из НастройкиУведомлений Цикл
			Если СтрокаНастроек.УведомлятьОХодеВыполненияТехническихПроектов
				ИЛИ СтрокаНастроек.УведомлятьОбИзмененииСтатусовТехническихПроектов Тогда
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаНастроек);
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	// Обработка настроек уведомлений о согласовании технических проектов
	
	МенеджерЗаписиНастроекУведомлений = РегистрыСведений.ПерсональныеНастройкиУведомленийПользователей.СоздатьМенеджерЗаписи();
	МенеджерЗаписиНастроекУведомлений.Пользователь = АвторизованныйПользователь;
	МенеджерЗаписиНастроекУведомлений.Прочитать();
	
	Если УведомлятьОНаправленииЗадачИсполнителю <> МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииЗадачИсполнителю Тогда
		МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииЗадачИсполнителю = УведомлятьОНаправленииЗадачИсполнителю;
	КонецЕсли;
		
	Если УведомлятьОНаправленииОшибокИсполнителю <> МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииОшибокИсполнителю Тогда
		МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииОшибокИсполнителю = УведомлятьОНаправленииОшибокИсполнителю;
	КонецЕсли;
	
	Если УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем <> МенеджерЗаписиНастроекУведомлений.УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем Тогда
		МенеджерЗаписиНастроекУведомлений.УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем =
			УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем;
	КонецЕсли;
	
	Если УведомлятьОСогласованииТехническихПроектов <> МенеджерЗаписиНастроекУведомлений.УведомлятьОСогласованииТехническихПроектов Тогда
		МенеджерЗаписиНастроекУведомлений.УведомлятьОСогласованииТехническихПроектов = УведомлятьОСогласованииТехническихПроектов;
	КонецЕсли;
	
	Если МенеджерЗаписиНастроекУведомлений.Модифицированность() Тогда
		МенеджерЗаписиНастроекУведомлений.Пользователь = АвторизованныйПользователь;
		МенеджерЗаписиНастроекУведомлений.Записать(Истина);
	КонецЕсли;
	
	МенеджерЗаписиНастроекУведомленийВTelegram = РегистрыСведений.TG_ПерсональныеНастройкиУведомленийВTelegram.СоздатьМенеджерЗаписи();
	МенеджерЗаписиНастроекУведомленийВTelegram.Пользователь = АвторизованныйПользователь;
	МенеджерЗаписиНастроекУведомленийВTelegram.Прочитать();
	
	Если TG_УведомлятьВTelegramОНаправленииЗадачИсполнителю <>
		МенеджерЗаписиНастроекУведомленийВTelegram.УведомлятьВTelegramОНаправленииЗадачИсполнителю Тогда
		
		МенеджерЗаписиНастроекУведомленийВTelegram.УведомлятьВTelegramОНаправленииЗадачИсполнителю = TG_УведомлятьВTelegramОНаправленииЗадачИсполнителю;
	КонецЕсли;
	
	Если TG_УведомлятьВTelegramОНаправленииОшибкиИсполнителю <>
		МенеджерЗаписиНастроекУведомленийВTelegram.УведомлятьВTelegramОНаправленииОшибки Тогда
		
		МенеджерЗаписиНастроекУведомленийВTelegram.УведомлятьВTelegramОНаправленииОшибки = TG_УведомлятьВTelegramОНаправленииОшибкиИсполнителю;
	КонецЕсли;

	
	Если МенеджерЗаписиНастроекУведомленийВTelegram.Модифицированность() Тогда
		МенеджерЗаписиНастроекУведомленийВTelegram.Пользователь = АвторизованныйПользователь;
		МенеджерЗаписиНастроекУведомленийВTelegram.Записать(Истина);
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура TG_ПриСозданииНаСервереВместо(Отказ, СтандартнаяОбработка)
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов", 
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина
	);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов", 
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл
	);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов", 
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка()
	);
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь
	);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь
	);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина
	);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьКолонкуРазмер",
		Ложь
	);
	
	// Заполняем настройки открытия файлов
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"Расширение",
			"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"СпособОткрытия",
			Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ИсторияКаталогИсполняемогоФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"КаталогИсполняемогоФайла",
		Новый Массив);
	Элементы.КаталогИсполняемогоФайла.СписокВыбора.ЗагрузитьЗначения(ИсторияКаталогИсполняемогоФайла);
	Если ИсторияКаталогИсполняемогоФайла.Количество() > 0 Тогда
		КаталогИсполняемогоФайла = ИсторияКаталогИсполняемогоФайла[ИсторияКаталогИсполняемогоФайла.Количество()-1];
	КонецЕсли; 
	
	ДополнительныеПараметрыЗапуска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"ДополнительныеПараметрыЗапуска");
	
	ТипБазыПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"ТипБазыПоУмолчанию",
		Перечисления.ТипБазы.Файловый);
	
	РасположениеЛокальнойКопииБазы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"РасположениеЛокальнойКопииБазы");
	
	СпособСозданияЛокальнойКопииБазыОшибки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"СпособСозданияЛокальнойКопииБазыОшибки",
		Перечисления.СпособыСозданияЛокальнойКопииБазыОшибки.СоздаватьКаталогПоКодуОшибки);
	
	НастройкиСерверныхБаз = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСОшибками", 
		"НастройкиСерверныхБаз",
		Новый Структура);
	
	
	НастройкиСерверныхБаз.Свойство("КластерСерверов1С",      КластерСерверов1С);
	НастройкиСерверныхБаз.Свойство("ТипСУБД",                ТипСУБД);
	НастройкиСерверныхБаз.Свойство("СмещениеДат",            СмещениеДат);
	НастройкиСерверныхБаз.Свойство("СерверБазыДанных",       СерверБазыДанных);
	НастройкиСерверныхБаз.Свойство("ПользовательСервераБазыДанных",         ПользовательСервераБазыДанных);
	НастройкиСерверныхБаз.Свойство("ПарольПользователяСервераБазыДанных",   ПарольПользователяСервераБазыДанных);
	
	Если НастройкиСерверныхБаз.Свойство("СоздаватьБазуДанныхВСлучаеОтстутствия") Тогда 
		СоздаватьБазуДанныхВСлучаеОтстутствия = НастройкиСерверныхБаз.СоздаватьБазуДанныхВСлучаеОтстутствия;
	Иначе 
		СоздаватьБазуДанныхВСлучаеОтстутствия = Истина;
	КонецЕсли;
	
	ИспользоватьЛокальныеКопииБазОшибок = ЗначениеЗаполнено(РасположениеЛокальнойКопииБазы)
	                                  ИЛИ ЗначениеЗаполнено(КластерСерверов1С)
	                                  ИЛИ ЗначениеЗаполнено(ТипСУБД)
	                                  ИЛИ ЗначениеЗаполнено(СмещениеДат)
	                                  ИЛИ ЗначениеЗаполнено(СерверБазыДанных)
	                                  ИЛИ ЗначениеЗаполнено(ПользовательСервераБазыДанных)
	                                  ИЛИ ЗначениеЗаполнено(ПарольПользователяСервераБазыДанных);
	
	
	РасположениеЛокальногоПутиРазработки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСБазамиРазработки", 
		"РасположениеЛокальногоПутиРазработки");
	
	
	КаталогДляДанныхТестирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Тестирование", 
		"КаталогДляДанныхТестирования");
	
	ФреймворкДляЗапускаТестов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Тестирование", 
		"ФреймворкДляЗапускаТестов");
	
	РепозиторийТестов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Тестирование", 
		"РепозиторийТестов");
	
	ТекстовыйРедактор = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Тестирование", 
		"ТекстовыйРедактор");
	
	БиблиотекиТестовИзНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Тестирование", 
		"БиблиотекиТестов");
	
	БиблиотекиТестов.Очистить();
	Если БиблиотекиТестовИзНастроек <> Неопределено Тогда
		Для Каждого ПутьКБиблиотеке Из БиблиотекиТестовИзНастроек Цикл
			СтрокаБиблиотекиТестов = БиблиотекиТестов.Добавить();
			СтрокаБиблиотекиТестов.Путь = ПутьКБиблиотеке;
		КонецЦикла;	
	КонецЕсли;	 

	
	ИспользоватьЛокальныеБазыРазработки = ЗначениеЗаполнено(РасположениеЛокальногоПутиРазработки);
	
	МенеджерЗаписиНастроекУведомлений = РегистрыСведений.ПерсональныеНастройкиУведомленийПользователей.СоздатьМенеджерЗаписи();
	МенеджерЗаписиНастроекУведомлений.Пользователь = АвторизованныйПользователь;
	МенеджерЗаписиНастроекУведомлений.Прочитать();
	
	МенеджерЗаписиНастроекУведомленийTelegram = РегистрыСведений.TG_ПерсональныеНастройкиУведомленийВTelegram.СоздатьМенеджерЗаписи();
	МенеджерЗаписиНастроекУведомленийTelegram.Пользователь = АвторизованныйПользователь;
	МенеджерЗаписиНастроекУведомленийTelegram.Прочитать();
	
	TG_УведомлятьВTelegramОНаправленииЗадачИсполнителю = МенеджерЗаписиНастроекУведомленийTelegram.УведомлятьВTelegramОНаправленииЗадачИсполнителю;
	TG_УведомлятьВTelegramОНаправленииОшибкиИсполнителю = МенеджерЗаписиНастроекУведомленийTelegram.УведомлятьВTelegramОНаправленииОшибки;
	
	УведомлятьОНаправленииЗадачИсполнителю = МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииЗадачИсполнителю;
		
	УведомлятьОНаправленииОшибокИсполнителю = МенеджерЗаписиНастроекУведомлений.УведомлятьОНаправленииОшибокИсполнителю;
	
	УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем =
		МенеджерЗаписиНастроекУведомлений.УведомлятьОбИсправленииОшибокЗарегистрированныхПользователем;
	
	УведомлятьОСогласованииТехническихПроектов = МенеджерЗаписиНастроекУведомлений.УведомлятьОСогласованииТехническихПроектов;
	
	ЗаполнитьТаблицуНастроекУведомлений();
	
	УправлениеДоступностью(ЭтаФорма);
КонецПроцедуры
