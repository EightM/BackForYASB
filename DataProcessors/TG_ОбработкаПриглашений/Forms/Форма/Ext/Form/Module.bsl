﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСписокПриглашений();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПриглашенныеСотрудники
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНовоеПриглашение(Команда)
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьЗакрытиеНовогоПриглашения", ЭтотОбъект, Параметры);
	ОткрытьФорму("Обработка.TG_ОбработкаПриглашений.Форма.НовоеПриглашение", , , , , ,ОповещениеОЗакрытии);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТекущиеПриглашения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	TG_Приглашения.Сотрудник КАК Сотрудник,
	|	TG_Приглашения.СсылкаПриглашения КАК СсылкаПриглашения
	|ИЗ
	|	РегистрСведений.TG_Приглашения КАК TG_Приглашения";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура ОбработатьЗакрытиеНовогоПриглашения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	ОбновитьСписокПриглашений();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПриглашений()
	Объект.ПриглашенныеСотрудники.Загрузить(ТекущиеПриглашения());
КонецПроцедуры
 
#КонецОбласти
