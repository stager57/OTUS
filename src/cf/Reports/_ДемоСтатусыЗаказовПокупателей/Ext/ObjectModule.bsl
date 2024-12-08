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

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	Настройки.События.ПриОпределенииИспользуемыхТаблиц = Истина;
	Настройки.Печать.ПолеСверху = 5;
	Настройки.Печать.ПолеСлева = 5;
	Настройки.Печать.ПолеСнизу = 5;
	Настройки.Печать.ПолеСправа = 5;
	Настройки.ФормироватьСразу = Истина;
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	Пользовательская = СвойстваНастройки.ПользовательскаяНастройка;
	Если Пользовательская <> Неопределено
		И Пользовательская.ТипЭлементов = "СписокСПодбором" Тогда // Вместо списка с флажками и командной панелью...
		Пользовательская.ТипЭлементов = "СвязьСКомпоновщиком"; // В.. выводится поле ввода, связанное с СКД.
	КонецЕсли;
	
	Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Пользователи")) Тогда
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
		СвойстваНастройки.ЗначенияДляВыбора.Очистить();
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст =
			"ВЫБРАТЬ Ссылка ИЗ Справочник.Пользователи
			|ГДЕ НЕ ПометкаУдаления И НЕ Недействителен И НЕ Служебный";
	КонецЕсли;
КонецПроцедуры

// Список регистров и других объектов метаданных, по которым формируется отчет.
//   Используется для проверки что отчет может содержать не обновленные данные.
//
// Параметры:
//   КлючВарианта - Строка
//                - Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   ИспользуемыеТаблицы - Массив - 
//       Полные имена объектов метаданных (регистров, документов и других таблиц),
//       данные которых выводятся в отчете.
//
// Пример:
//	ИспользуемыеТаблицы.Добавить(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя());
//
Процедура ПриОпределенииИспользуемыхТаблиц(КлючВарианта, ИспользуемыеТаблицы) Экспорт
	
	ИспользуемыеТаблицы.Добавить(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя());
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли