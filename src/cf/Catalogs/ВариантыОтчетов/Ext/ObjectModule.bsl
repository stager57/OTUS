﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если Не Пользовательский Тогда
		ИсключаемыеРеквизиты.Добавить("Автор");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	Если Наименование <> "" И ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" занято, укажите другое наименование.'"), Наименование),
			,
			"Наименование");
		КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ПользователемИзмененаПометкаУдаления = (
		Не ЭтоНовый()
		И ПометкаУдаления <> Ссылка.ПометкаУдаления
		И Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных"));
	
	Если Не Пользовательский И ПользователемИзмененаПометкаУдаления Тогда
		Если ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Пометка на удаление предопределенного варианта отчета запрещена.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Снятие пометки удаления предопределенного варианта отчета запрещено.'");
		КонецЕсли;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Не ПометкаУдаления И ПользователемИзмененаПометкаУдаления Тогда
		НаименованиеЗанято = ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование);
		КлючВариантаЗанят  = ВариантыОтчетов.КлючВариантаЗанят(Отчет, Ссылка, КлючВарианта);
		Если НаименованиеЗанято ИЛИ КлючВариантаЗанят Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка снятия пометки удаления варианта отчета:'");
			Если НаименованиеЗанято Тогда
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Наименование ""%1"" уже занято другим вариантом этого отчета.'"),
					Наименование);
			Иначе
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ключ варианта ""%1"" уже занят другим вариантом этого отчета.'"),
					КлючВарианта);
			КонецЕсли;
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Перед снятием пометки удаления варианта отчета
				|установите пометку удаления конфликтующего варианта отчета.'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
	
	Если ПользователемИзмененаПометкаУдаления Тогда
		ИнтерактивнаяПометкаУдаления = ?(Пользовательский, ПометкаУдаления, Ложь);
	КонецЕсли;
	
	ПроверитьРазмещение();
	ЗаполнитьПоляДляПоиска();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПользователиВарианта = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "ПользователиВарианта");
	ЭтоНовый = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "ЭтоНовый", Ложь);
	УведомитьПользователей = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "УведомитьПользователей", Ложь);
	
	РегистрыСведений.НастройкиВариантовОтчетов.ЗаписатьНастройкиДоступностиВариантаОтчета(
		Ссылка, ЭтоНовый, ПользователиВарианта, УведомитьПользователей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	НастройкиВариантаОтчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеЗаполнения, "Настройки");
	
	Если ТипЗнч(НастройкиВариантаОтчета) = Тип("НастройкиКомпоновкиДанных") Тогда 
		
		Настройки = Новый ХранилищеЗначения(НастройкиВариантаОтчета);
		
	КонецЕсли;
	
	#Область УстановкаТипаОтчета
	
	Если ТипЗнч(Отчет) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда 
		
		ТипОтчета = Перечисления.ТипыОтчетов.Внутренний;
		
	ИначеЕсли ТипЗнч(Отчет) = Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений") Тогда 
		
		ТипОтчета = Перечисления.ТипыОтчетов.Расширение;
		
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки")
		И ТипЗнч(Отчет) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда 
		
		ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный;
		
	ИначеЕсли ТипЗнч(Отчет) = Тип("Строка") Тогда 
		
		ТипОтчета = Перечисления.ТипыОтчетов.Внешний;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область УстановкаДанныхВЗависимостиОтЗначенияАвтора
	
	Если ЗначениеЗаполнено(Автор) Тогда 
		
		Пользовательский = ЗначениеЗаполнено(Автор);
		
		ПользователиВарианта = Новый СписокЗначений;
		ПользователиВарианта.Добавить(Автор,, Истина);
		
		ДополнительныеСвойства.Вставить("ПользователиВарианта", ПользователиВарианта);
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область УстановкаРодителя
	
	Основание = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеЗаполнения, "Основание");
	
	Если ТипЗнч(Основание) = ТипЗнч(Ссылка) Тогда 
		
		СвойстваОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Основание, "Родитель, Отчет, Пользовательский, Размещение");
		
		Если СвойстваОснования.Отчет = Отчет Тогда 
			Родитель = ?(СвойстваОснования.Пользовательский, СвойстваОснования.Родитель, Основание);
		КонецЕсли;
		
		Размещение.Загрузить(СвойстваОснования.Размещение.Выгрузить());
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Родитель) Тогда 
		ЗаполнитьРодителя();
	КонецЕсли;
	
	ЗаполнитьРазмещениеПоРодителю();
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРазмещение()
	
	Если ЗначениеЗаполнено(Контекст) Тогда 
		
		Размещение.Очистить();
		Возврат;
		
	КонецЕсли;
	
	// Удаление из табличной части подсистем, помеченных на удаление.
	УдаляемыеСтроки = Новый Массив;
	Для Каждого СтрокаРазмещения Из Размещение Цикл
		
		Если СтрокаРазмещения.Подсистема.ПометкаУдаления = Истина Тогда
			УдаляемыеСтроки.Добавить(СтрокаРазмещения);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаРазмещения Из УдаляемыеСтроки Цикл
		Размещение.Удалить(СтрокаРазмещения);
	КонецЦикла;
	
КонецПроцедуры

// Заполнение реквизитов НаименованияПолей и НаименованияПараметровИОтборов.
Процедура ЗаполнитьПоляДляПоиска()
	
	Дополнительный = (ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный);
	Если Не Пользовательский И Не Дополнительный Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УстановитьОтключениеБезопасногоРежима(Истина);
		УстановитьПривилегированныйРежим(Истина);
		ВариантыОтчетов.ЗаполнитьПоляДляПоиска(ЭтотОбъект);
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проиндексировать схему варианта ""%1"" отчета ""%2"":'"),
			КлючВарианта, Строка(Отчет));
		ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВариантыОтчетов.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки, Ссылка);
	КонецПопытки;
	
КонецПроцедуры

// Заполняет родителя варианта отчета, основываясь на ссылке отчета и предопределенных настройках.
Процедура ЗаполнитьРодителя() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПредопределенныеВарианты.Ссылка,
	|	ПредопределенныеВарианты.Включен
	|ПОМЕСТИТЬ ПредопределенныеВарианты
	|ИЗ
	|	Справочник.ПредопределенныеВариантыОтчетов КАК ПредопределенныеВарианты
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(&Отчет) <> ТИП(Справочник.ИдентификаторыОбъектовРасширений)
	|	И ПредопределенныеВарианты.Отчет = &Отчет
	|	И НЕ ПредопределенныеВарианты.ПометкаУдаления
	|	И ПредопределенныеВарианты.ГруппироватьПоОтчету
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПредопределенныеВарианты.Ссылка,
	|	ПредопределенныеВарианты.Включен
	|ИЗ
	|	Справочник.ПредопределенныеВариантыОтчетовРасширений КАК ПредопределенныеВарианты
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредопределенныеВариантыОтчетовВерсийРасширений КАК ДоступныеВарианты
	|		ПО ДоступныеВарианты.Вариант = ПредопределенныеВарианты.Ссылка
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(&Отчет) = ТИП(Справочник.ИдентификаторыОбъектовРасширений)
	|	И ПредопределенныеВарианты.Отчет = &Отчет
	|	И ПредопределенныеВарианты.ГруппироватьПоОтчету
	|	И НЕ ДоступныеВарианты.Вариант ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПредопределенныеВарианты.Включен УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Ссылка
	|ИЗ
	|	ПредопределенныеВарианты КАК ПредопределенныеВарианты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|		ПО ПредопределенныеВарианты.Ссылка = ВариантыОтчетов.ПредопределенныйВариант
	|ГДЕ
	|	НЕ ВариантыОтчетов.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Отчет", Отчет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Родитель = Выборка.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРазмещениеПоРодителю()
	
	Если Размещение.Количество() > 0
		Или Не ЗначениеЗаполнено(Родитель) Тогда 
		
		Возврат;
	КонецЕсли;
	
	СвойстваРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Родитель, "ПредопределенныйВариант, Размещение");
	
	Размещение.Загрузить(СвойстваРодителя.Размещение.Выгрузить());
	
	Если Размещение.Количество() > 0
		Или Не ЗначениеЗаполнено(СвойстваРодителя.ПредопределенныйВариант) Тогда 
		
		Возврат;
	КонецЕсли;
	
	РазмещениеПредопределенногоВарианта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		СвойстваРодителя.ПредопределенныйВариант, "Размещение");
	
	Размещение.Загрузить(РазмещениеПредопределенногоВарианта.Выгрузить());
	
	Для Каждого Строка Из Размещение Цикл 
		Строка.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Базовые проверки корректности данных предопределенных вариантов отчетов.
Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	
	Если ПометкаУдаления Или Не Предопределенный Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет) Тогда
		ТекстОшибки = НеЗаполненоПоле("Отчет");
	ИначеЕсли Не ЗначениеЗаполнено(ТипОтчета) Тогда
		ТекстОшибки = НеЗаполненоПоле("ТипОтчета");
	ИначеЕсли ТипОтчета <> ВариантыОтчетов.ТипОтчета(Отчет) Тогда
		ТекстОшибки = НСтр("ru = 'Противоречивые значения полей ""%1"" и ""%2""'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, "ТипОтчета", "Отчет");
	ИначеЕсли Не ЗначениеЗаполнено(ПредопределенныйВариант)
		И (ТипОтчета = Перечисления.ТипыОтчетов.Внутренний Или ТипОтчета = Перечисления.ТипыОтчетов.Расширение) Тогда
		ТекстОшибки = НеЗаполненоПоле("ПредопределенныйВариант");
	Иначе
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение ТекстОшибки;
	
КонецПроцедуры

Функция НеЗаполненоПоле(ИмяПоля)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнено поле ""%1""'"), ИмяПоля);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли