﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет задать настройки для регистрации событий доступа к персональным данным.
//
// При расширении состава субъектов персональных данных следует иметь в виду, что регистрация событий для них
// не начнется автоматически (это отдельно настраивает администратор программы). Однако если необходимо управлять этим
// при переходе на новую версию программы, то следует реализовать обработчик обновления, вызывающий 
// процедуру ЗащитаПерсональныхДанных.УстановитьИспользованиеСобытияДоступ.
//
// Параметры:
//   ТаблицаСведений    - ТаблицаЗначений:
//    * Объект          - Строка - полное имя объекта метаданных с персональными данными;
//    * ПоляРегистрации - Строка - имена полей, значения которых выводятся в журнал событий доступа к персональным
//                                 данным для идентификации субъекта персональных данных. Для ссылочных типов, 
//                                 как правило, это поле "Ссылка". Отдельные поля регистрации отделяются запятой, 
//                                 альтернативные - символом "|";
//    * ПоляДоступа     - Строка - имена полей доступа через запятую. Обращение (попытка доступа) к этим полям 
//                                 приводит к записи журнала;
//    * ОбластьДанных   - Строка - идентификатор области данных, если их несколько. Необязательно для заполнения.
//
// Пример:
//  Сведения = ТаблицаСведений.Добавить();
//  Сведения.Объект				= "Справочник.ФизическиеЛица";
//  Сведения.ПоляРегистрации	= "Ссылка";
//  Сведения.ПоляДоступа		= "Наименование,ДатаРождения";
//  Сведения.ОбластьДанных		= "ЛичныеДанные";
//
//  Сведения = ТаблицаСведений.Добавить();
//  Сведения.Объект				= "Справочник.ФизическиеЛица";
//  Сведения.ПоляРегистрации	= "Ссылка";
//  Сведения.ПоляДоступа		= "СерияДокумента,НомерДокумента,КемВыданДокумент,ДатаВыдачиДокумента";
//  Сведения.ОбластьДанных		= "ПаспортныеДанные";
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	// _Демо начало примера
	Сведения = ТаблицаСведений.Добавить();
	Сведения.Объект				= "Справочник._ДемоФизическиеЛица";
	Сведения.ПоляРегистрации	= "Ссылка";
	Сведения.ПоляДоступа		= "Наименование,ДатаРождения";
	Сведения.ОбластьДанных		= "ЛичныеДанные";
	
	Сведения = ТаблицаСведений.Добавить();
	Сведения.Объект				= "Справочник._ДемоФизическиеЛица";
	Сведения.ПоляРегистрации	= "Ссылка";
	Сведения.ПоляДоступа		= "СерияДокумента,НомерДокумента,КемВыданДокумент,ДатаВыдачиДокумента";
	Сведения.ОбластьДанных		= "ПаспортныеДанные";
	
	Сведения = ТаблицаСведений.Добавить();
	Сведения.Объект				= "Документ._ДемоНачислениеЗарплаты";
	Сведения.ПоляРегистрации	= "Зарплата.ФизическоеЛицо";
	Сведения.ПоляДоступа		= "Зарплата.Сумма";
	Сведения.ОбластьДанных		= "Доходы";
	
	Сведения = ТаблицаСведений.Добавить();
	Сведения.Объект				= "РегистрРасчета._ДемоОсновныеНачисления";
	Сведения.ПоляРегистрации	= "ФизическоеЛицо";
	Сведения.ПоляДоступа		= "Результат";
	Сведения.ОбластьДанных		= "Доходы";
	// _Демо конец примера
	
КонецПроцедуры

// Обеспечивает составление коллекции областей персональных данных.
//
// Параметры:
//    ОбластиПерсональныхДанных - ТаблицаЗначений:
//      * Имя			- Строка - идентификатор области данных.
//      * Представление	- Строка - пользовательское представление области данных.
//      * Родитель		- Строка - идентификатор родительской области данных.
//
Процедура ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных) Экспорт
	
	// _Демо начало примера
	// Заполнение представлений для используемых областей.
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "ЛичныеДанные";
	НоваяОбласть.Представление = НСтр("ru = 'Личные данные'");
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "ПаспортныеДанные";
	НоваяОбласть.Представление = НСтр("ru = 'Паспортные данные'");
	НоваяОбласть.Родитель = "ЛичныеДанные";
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными, 
// переданных в качестве параметров, субъектов.
//
// Параметры:
//    СубъектыПерсональныхДанных 	- ДанныеФормыКоллекция - содержит сведения о субъектах.
//    ДатаАктуальности			- Дата - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеСубъектовПерсональныхДанных(СубъектыПерсональныхДанных, ДатаАктуальности) Экспорт
	
	// _Демо начало примера
	// Пример заполнения данных для субъектов типов: Физические лица, _ДемоКонтактныеЛицаПартнеров, _ДемоКонтрагенты,
	// _ДемоПартнеры.
	Для Каждого СтрокаСубъект Из СубъектыПерсональныхДанных Цикл
		Если ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка._ДемоФизическиеЛица") Тогда
			ИменаРеквизитов = "Наименование, СерияДокумента, НомерДокумента, КемВыданДокумент, ДатаВыдачиДокумента";
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаСубъект.Субъект, ИменаРеквизитов);
			// Заполнение реквизитов.
			СтрокаСубъект.ФИО = ЗначенияРеквизитов.Наименование;
			Если ЗначениеЗаполнено(ЗначенияРеквизитов.СерияДокумента)
				Или ЗначениеЗаполнено(ЗначенияРеквизитов.НомерДокумента)
				Или ЗначениеЗаполнено(ЗначенияРеквизитов.КемВыданДокумент)
				Или ЗначениеЗаполнено(ЗначенияРеквизитов.ДатаВыдачиДокумента) Тогда
				СтрокаСубъект.ПаспортныеДанные = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Серия %1, номер %2, выдан %3 %4'"), 
					ЗначенияРеквизитов.СерияДокумента, 
					ЗначенияРеквизитов.НомерДокумента, 
					ЗначенияРеквизитов.КемВыданДокумент, 
					Формат(ЗначенияРеквизитов.ДатаВыдачиДокумента, "ДЛФ=D"));
			КонецЕсли;
		ИначеЕсли ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка._ДемоКонтактныеЛицаПартнеров") Тогда
			ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСубъект.Субъект, "ФизическоеЛицо");
			СтрокаСубъект.ФИО = Строка(ФизическоеЛицо);
			СтрокаСубъект.Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаСубъект.Субъект, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоАдресКонтактногоЛица"));
		ИначеЕсли ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка._ДемоКонтрагенты") Тогда	
			СтрокаСубъект.ФИО = Строка(СтрокаСубъект.Субъект);
			СтрокаСубъект.Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаСубъект.Субъект, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоАдресКонтрагента"));
		ИначеЕсли ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка._ДемоПартнеры") Тогда	
			СтрокаСубъект.ФИО = Строка(СтрокаСубъект.Субъект);
			СтрокаСубъект.Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаСубъект.Субъект, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоАдресПартнера"));
		КонецЕсли;
	КонецЦикла;
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными организации.
//
// Параметры:
//    Организация			- ОпределяемыйТип.Организация - оператор персональных данных.
//    ДанныеОрганизации	- Структура - данные об организации (адрес, ФИО ответственного и т.д.).
//    ДатаАктуальности	- Дата      - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Организация, ДанныеОрганизации, ДатаАктуальности) Экспорт
	
	// _Демо начало примера
	ДанныеОрганизации.Вставить("НаименованиеОрганизации", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "НаименованиеПолное"));
	ДанныеОрганизации.Вставить("АдресОрганизации", 
		УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоЮридическийАдресОрганизации"), ДатаАктуальности));
	// _Демо конец примера

КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных".
// Предназначена для заполнения поля ФИО ответственного за обработку ПДн.
//
// Параметры:
//    ФизическоеЛицо	- ОпределяемыйТип.ФизическоеЛицо - ответственный за обработку персональных данных.
//    ФИО				- Строка - ФИО ответственного, которые нужно заполнить.
//
Процедура ЗаполнитьФИОФизическогоЛица(ФизическоеЛицо, ФИО) Экспорт
	
	// _Демо начало примера
	ФИО = Строка(ФизическоеЛицо);
	// _Демо конец примера
	
КонецПроцедуры

// Позволяет проверить возможность скрытия персональных данных и задать состав исключений для записи в данных.
//
// Параметры:
//   Субъекты - Массив - ссылки на объекты данных, чьи персональные данные будут скрыты.
//   ТаблицаИсключений - ТаблицаЗначений - таблица, в которую добавляются субъекты и причины отказа их скрытия.
//   							Состав полей см. в функции ЗащитаПерсональныхДанных.НоваяТаблицаИсключений.
//   Отказ - Булево - (по умолчанию Истина) признак отказа от скрытия. Если конфигурация адаптирована к обменам, и
//   							определены причины отказа от скрытия, то параметру необходимо установить значение Ложь.
//
Процедура ПередСкрытиемПерсональныхДанныхСубъектов(Субъекты, ТаблицаИсключений, Отказ) Экспорт

	// _Демо начало примера
	_ДемоСтандартныеПодсистемы.ПередСкрытиемПерсональныхДанныхСубъектов(Субъекты, ТаблицаИсключений, Отказ);
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
