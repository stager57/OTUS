﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиПользователя = Параметры.НастройкиПользователя;
	Сертификат = Параметры.Сертификат;
	Если Сертификат <> Неопределено Тогда
		СертификатПредставление = Сертификат.Представление;
	КонецЕсли;
	СкрыватьПароль = СервисКриптографииDSSСлужебный.НужнаяВерсияПлатформы("8.3.19.0");
	
	ПодготовитьФорму(Параметры);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму(РезультатРаботы());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВидимостьЭлемента("Пароль");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗакрытьФорму(РезультатРаботы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ПодтвердитьПароль();
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПинКод(Команда)
	
	ОповещениеОЗавершении = ОписаниеОповещенияОЗакрытии;
	ОписаниеОповещенияОЗакрытии = Неопределено;
	ЗакрытьФорму(РезультатРаботы());
	СервисКриптографииDSSКлиент.СменитьПинКодСертификата(ОповещениеОЗавершении, НастройкиПользователя, Сертификат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция РезультатРаботы(Подтвердил = Ложь)
	
	Результат = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Подтвердил);
	Результат.Вставить("Результат", ЗакрытьДанныеПользователя(Пароль));
	Результат.Вставить("Сохранить", Сохранить);
	
	Если НЕ Подтвердил Тогда
		СервисКриптографииDSSСлужебныйКлиент.ПолучитьОписаниеОшибки(Результат, "ОтказПользователя");
	КонецЕсли;

	Возврат Результат;
	
КонецФункции	

&НаКлиенте
Процедура ЗакрытьФорму(РезультатЗакрытия)
	
	ПрограммноеЗакрытие = Истина;
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПароль()
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		ЗакрытьФорму(РезультатРаботы(Истина));
	Иначе
		ТекущийЭлемент = Элементы.Пароль;
		Ошибка = Истина;
		ПодключитьОбработчикОжидания("ОтключитьОшибку", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтключитьОшибку()
	
	Ошибка = Ложь;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьВидимостьЭлемента(ИмяЭлемента)
	
	Элементы[ИмяЭлемента].КартинкаКнопкиВыбора = КартинкаОткрыть;
	Элементы[ИмяЭлемента].РежимПароля = Ложь;
	ЭтотОбъект[ИмяЭлемента] = Элементы[ИмяЭлемента].ТекстРедактирования;
	Если СкрыватьПароль Тогда
		ПодключитьОбработчикОжидания("ПодключаемыйОтключитьВидимостьПароля", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемыйОтключитьВидимостьПароля()
	
	ЭлементФормы = Элементы["Пароль"];
	Если ЭлементФормы.РежимПароля <> Истина Тогда
		ТекущийТекст = ЭлементФормы.ТекстРедактирования;
		ЭлементФормы.КартинкаКнопкиВыбора = КартинкаЗакрыть;
		ЭлементФормы.РежимПароля = Истина;
		ЭтотОбъект["Пароль"] = ТекущийТекст;
		ЭлементФормы.ОбновитьТекстРедактирования();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОперации = СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации(Ложь);
	ПараметрыОперации.ИдентификаторОперации = УникальныйИдентификатор;
	ПараметрыОперации.Вставить("ФормаВладелец", ЭтотОбъект);
	
	СервисКриптографииDSSКлиент.ПоказатьСертификат(
		Неопределено, 
		НастройкиПользователя,
		Сертификат,
		ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Функция ЗакрытьДанныеПользователя(ВведенноеЗначение) 
	
	ПризнакКонфиденциальности = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(НастройкиПользователя, "ПризнакКонфиденциальности", 1);
	
	Возврат СервисКриптографииDSSКлиент.ПодготовитьОбъектПароля(ВведенноеЗначение, ПризнакКонфиденциальности);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	ЭлементФормы = КонтекстФормы.Элементы;
	ЭлементФормы.Сохранить.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФорму(ПараметрыФормы)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	Заголовок = НСтр("ru = 'Доступ к закрытому ключу пользователя'", КодЯзыка);
	Если ПараметрыФормы.Свойство("ЗаголовокФормы") Тогда
		ЗаголовокФормы = ПараметрыФормы.ЗаголовокФормы;
	Иначе
		ЗаголовокФормы = НСтр("ru = 'Укажите пин-код к закрытому ключу сертификата'", КодЯзыка);
	КонецЕсли;
	Элементы.ЗаголовокФормы.Заголовок = ЗаголовокФормы;
	
	КартинкаОткрыть = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ВидимостьПароляОткрыто");
	КартинкаЗакрыть = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ВидимостьПароляЗакрыто");
	
	Элементы.Пароль.КартинкаКнопкиВыбора = КартинкаЗакрыть;
	
КонецПроцедуры	

#КонецОбласти
