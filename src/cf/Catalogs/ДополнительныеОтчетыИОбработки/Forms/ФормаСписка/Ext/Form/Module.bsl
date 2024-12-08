﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если Параметры.Свойство("Отображение") Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы[Параметры.Отображение];
	КонецЕсли;
	
	СписокВыбораПубликаций = Элементы.ПубликацияОтбор.СписокВыбора;
	
	ВидИспользуется = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
	ВидРежимОтладки = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
	
	ДоступныеВидыПубликации = ДополнительныеОтчетыИОбработкиПовтИсп.ДоступныеВидыПубликации();
	
	ВсеПубликацииКромеНеиспользующихся = Новый Массив;
	ВсеПубликацииКромеНеиспользующихся.Добавить(ВидИспользуется);
	Если ДоступныеВидыПубликации.Найти(ВидРежимОтладки) <> Неопределено Тогда
		ВсеПубликацииКромеНеиспользующихся.Добавить(ВидРежимОтладки);
	КонецЕсли;
	Если ВсеПубликацииКромеНеиспользующихся.Количество() > 1 Тогда
		ПредставлениеМассива = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 или %2'"),
			Строка(ВсеПубликацииКромеНеиспользующихся[0]),
			Строка(ВсеПубликацииКромеНеиспользующихся[1]));
		СписокВыбораПубликаций.Добавить(1, ПредставлениеМассива);
	КонецЕсли;
	Для Каждого ЗначениеПеречисления Из Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок Цикл
		Если ДоступныеВидыПубликации.Найти(ЗначениеПеречисления) <> Неопределено Тогда
			СписокВыбораПубликаций.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Отбор.Свойство("Публикация") Тогда
		ПубликацияОтбор = Параметры.Отбор.Публикация;
		Параметры.Отбор.Удалить("Публикация");
		Если СписокВыбораПубликаций.НайтиПоЗначению(ПубликацияОтбор) = Неопределено Тогда
			ПубликацияОтбор = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	СписокВыбора = Элементы.ВидОтбор.СписокВыбора;
	СписокВыбора.Добавить(1, НСтр("ru = 'Только отчеты'"));
	СписокВыбора.Добавить(2, НСтр("ru = 'Только обработки'"));
	Для Каждого ЗначениеПеречисления Из Перечисления.ВидыДополнительныхОтчетовИОбработок Цикл
		СписокВыбора.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
	КонецЦикла;
	
	ВидыДопОтчетов = Новый Массив;
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет);
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет);
	
	Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор",        ВидОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыДопОтчетов",  ВидыДопОтчетов);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПубликацииКромеНеиспользующихся", ВсеПубликацииКромеНеиспользующихся);
	
	ПравоДобавления = ДополнительныеОтчетыИОбработки.ПравоДобавления();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Создать",              "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьМеню",          "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьГруппу",        "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьГруппуМеню",    "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Скопировать",          "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СкопироватьМеню",      "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьИзФайла",     "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьИзФайлаМеню", "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыгрузитьВФайл",       "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыгрузитьВФайлМеню",   "Видимость", ПравоДобавления);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
		Или Не ПравоДоступа("Изменение", Метаданные.Справочники.ДополнительныеОтчетыИОбработки) Тогда
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
		Элементы.ИзменитьВыделенныеМеню.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроверкаДополнительныхОтчетовИОбработок") Тогда
		Элементы.Создать.Видимость = Ложь;
		Элементы.СоздатьГруппу.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаПояснениеСервис.Видимость = ОбщегоНазначения.РазделениеВключено();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Если Не ЗначениеЗаполнено(ПубликацияОтбор) Тогда
		ПубликацияОтбор = Настройки.Получить("ПубликацияОтбор");
		Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	КонецЕсли;
	ВидОтбор = Настройки.Получить("ВидОтбор");
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор", ВидОтбор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПубликацияОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ПубликацияОтбор");
	Если ЗначениеПараметраКД.Значение <> ПубликацияОтбор Тогда
		ЗначениеПараметраКД.Значение = ПубликацияОтбор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ВидОтбор");
	Если ЗначениеПараметраКД.Значение <> ВидОтбор Тогда
		ЗначениеПараметраКД.Значение = ВидОтбор;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или Не ВыбранЭлемент(ДанныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("Ссылка",   ДанныеСтроки.Ссылка);
	ПараметрыВыгрузки.Вставить("ЭтоОтчет", ДанныеСтроки.ЭтоОтчет);
	ПараметрыВыгрузки.Вставить("ИмяФайла", ДанныеСтроки.ИмяФайла);
	ДополнительныеОтчетыИОбработкиКлиент.ВыгрузитьВФайл(ПараметрыВыгрузки);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлОбработкиОтчета(Команда)
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или Не ВыбранЭлемент(ДанныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ДанныеСтроки.Ссылка);
	ПараметрыФормы.Вставить("ПоказатьДиалогЗагрузкиИзФайлаПриОткрытии", Истина);
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
	МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияИспользуется(Команда)
	ИзменитьПубликацию("Используется");
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияОтключена(Команда)
	ИзменитьПубликацию("Отключена");
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияРежимОтладки(Команда)
	ИзменитьПубликацию("РежимОтладки");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ВыбранЭлемент(ДанныеСтроки)
	Если ТипЗнч(ДанныеСтроки.Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.
			|Выберите дополнительный отчет или обработку.'"));
		Возврат Ложь;
	КонецЕсли;
	Если ДанныеСтроки.ЭтоГруппа Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для группы.
			|Выберите дополнительный отчет или обработку.'"));
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	//
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	//
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПубликацию(ВариантПубликации)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один дополнительный отчет (обработка)'"));
		Возврат;
	КонецЕсли;
	
	ИзменениеПубликации(ВариантПубликации);
	
	Если КоличествоСтрок = 1 Тогда
		ТекстСообщения = НСтр("ru = 'Изменена публикация дополнительного отчета (обработки) ""%1""'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(ВыделенныеСтроки[0]));
	Иначе
		ТекстСообщения = НСтр("ru = 'Изменена публикация у дополнительных отчетов (обработок): %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КоличествоСтрок);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Изменена публикация'"),, ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеПубликации(ВариантПубликации)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ДополнительныйОтчетИлиОбработка Из ВыделенныеСтроки Цикл
			ЗаблокироватьДанныеДляРедактирования(ДополнительныйОтчетИлиОбработка);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ДополнительныеОтчетыИОбработки");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ДополнительныйОтчетИлиОбработка);
			Блокировка.Заблокировать();
		КонецЦикла;
		
		Для Каждого ДополнительныйОтчетИлиОбработка Из ВыделенныеСтроки Цикл
			Объект = ДополнительныйОтчетИлиОбработка.ПолучитьОбъект();
			Если ВариантПубликации = "Используется" Тогда
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
			ИначеЕсли ВариантПубликации = "РежимОтладки" Тогда
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
			Иначе
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
			КонецЕсли;
			
			Объект.ДополнительныеСвойства.Вставить("ПроверкаСписка");
			Если Не Объект.ПроверитьЗаполнение() Тогда
				ПредставлениеОшибки = "";
				МассивСообщений = ПолучитьСообщенияПользователю(Истина);
				Для Каждого СообщениеПользователю Из МассивСообщений Цикл
					ПредставлениеОшибки = ПредставлениеОшибки + СообщениеПользователю.Текст + Символы.ПС;
				КонецЦикла;
				
				ВызватьИсключение ПредставлениеОшибки;
			КонецЕсли;
			
			Объект.Записать();
		КонецЦикла;
		
		РазблокироватьДанныеДляРедактирования();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		РазблокироватьДанныеДляРедактирования();
		ВызватьИсключение;
	КонецПопытки;
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
