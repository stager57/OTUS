﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	Иначе
		Возврат;
	КонецЕсли;
	
	ДоступнаУсовершенствованнаяПодпись = ЭлектроннаяПодписьСлужебныйПовтИсп.ДоступнаУсовершенствованнаяПодпись();
	
	Если Не ОбщегоНазначения.РазделениеВключено()
		Или ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		УсовершенствоватьПодписиАвтоматически = Константы.УсовершенствоватьПодписиАвтоматически.Получить();
		ДобавлятьМеткиВремениАвтоматически = Константы.ДобавлятьМеткиВремениАвтоматически.Получить();
	Иначе
		УсовершенствоватьПодписиАвтоматически = 0;
		ДобавлятьМеткиВремениАвтоматически = Ложь;
	КонецЕсли;
	
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.Описание = НСтр("ru = 'Подписи, срок действия которых должен быть продлен.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "НеобработанныеПодписи");
	НастройкиВарианта.Описание = НСтр("ru = 'Выводит подписи, у которых нужно определить тип и усовершенствовать согласно настройкам.'");
	НастройкиВарианта.Включен = ДоступнаУсовершенствованнаяПодпись И УсовершенствоватьПодписиАвтоматически <> 0;

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТребуетсяУсовершенствоватьПодписи");
	НастройкиВарианта.Описание = НСтр("ru = 'Выводит подписи, которые требуется усовершенствовать.'");
	НастройкиВарианта.Включен = ДоступнаУсовершенствованнаяПодпись И УсовершенствоватьПодписиАвтоматически <> 0;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТребуетсяДобавитьАрхивныеМетки");
	НастройкиВарианта.Описание = НСтр("ru = 'Выводит подписи, в которые пора добавить архивные метки.'");
	НастройкиВарианта.Включен = ДоступнаУсовершенствованнаяПодпись И ДобавлятьМеткиВремениАвтоматически;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОшибкиПриАвтоматическомПродлении");
	НастройкиВарианта.Описание = НСтр("ru = 'Выводит подписи, при автоматическом продлении которых произошла ошибка.'");
	НастройкиВарианта.Включен = ДоступнаУсовершенствованнаяПодпись
	 И (ДобавлятьМеткиВремениАвтоматически Или УсовершенствоватьПодписиАвтоматически = 1);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли