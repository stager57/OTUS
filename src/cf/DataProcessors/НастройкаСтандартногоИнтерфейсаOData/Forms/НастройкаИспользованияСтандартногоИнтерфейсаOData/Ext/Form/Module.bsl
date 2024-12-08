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
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для настройки автоматического REST-сервиса'");
	КонецЕсли;
	
	НастройкиАвторизации = Обработки.НастройкаСтандартногоИнтерфейсаOData.НастройкиАвторизацииДляСтандартногоИнтерфейсаOData();
	СоздатьПользователяСтандартногоИнтерфейсаOData = НастройкиАвторизации.Используется;
	
	Если ЗначениеЗаполнено(НастройкиАвторизации.Логин) Тогда
		
		ИмяПользователя = НастройкиАвторизации.Логин;
		Если СоздатьПользователяСтандартногоИнтерфейсаOData Тогда
			
			ПроверкаИзмененияПароля = Строка(Новый УникальныйИдентификатор());
			Пароль = ПроверкаИзмененияПароля;
			ПодтверждениеПароля = ПроверкаИзмененияПароля;
			
		КонецЕсли;
		
	Иначе
		ИмяПользователя = "odata.user";
	КонецЕсли;
		
	УстановитьВидимостьИДоступность();
	УстановитьУсловноеОформление();
	
	Элементы.ДекорацияДокументация.Заголовок = СтроковыеФункции.ФорматированнаяСтрока("<a href=""%1"">%2</a>",
		"http://its.1c.ru/db/v83doc#bookmark:dev:ti000001358",
		НСтр("ru = 'Документация по использованию автоматического REST-сервиса'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не СоздатьПользователяСтандартногоИнтерфейсаOData Тогда
		Возврат;
	КонецЕсли;
		
	ПроверяемыеРеквизиты.Добавить("ИмяПользователя");
	ПроверяемыеРеквизиты.Добавить("Пароль");
	ПроверяемыеРеквизиты.Добавить("ПодтверждениеПароля");
	
	Если Пароль <> ПодтверждениеПароля Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Подтверждение пароля не совпадает с паролем'"), , "ПодтверждениеПароля");
		Отказ = Истина;
	КонецЕсли;
	
	Если ОбъектыМетаданных.ПолучитьЭлементы().Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не указаны объекты, доступ к которым может быть предоставлен через автоматический REST-сервис.'"),, 
			"ОбъектыМетаданных");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗакрытиеПослеВопроса", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектыМетаданныхИспользованиеПриИзменении(Элемент)
	
	Если Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование Тогда
		Добавление = Истина;
		Зависимости = ЗависимостиДляДобавленияОбъекта(Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		Добавление = Ложь;
		Зависимости = ЗависимостиДляУдаленияОбъекта(Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;
	
	Если Зависимости.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ПолноеИмяОбъекта", Элементы.ОбъектыМетаданных.ТекущиеДанные.ПолноеИмя);
		ПараметрыФормы.Вставить("ЗависимостиОбъекта", Зависимости);
		ПараметрыФормы.Вставить("Добавление", Добавление);
		
		Контекст = Новый Структура();
		Контекст.Вставить("Зависимости", Зависимости);
		Контекст.Вставить("Добавление", Добавление);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбъектыМетаданныхИспользованиеПриИзмененииПродолжение", ЭтотОбъект, Контекст);
		
		ОткрытьФорму("Обработка.НастройкаСтандартногоИнтерфейсаOData.Форма.ЗависимостиОбъектаМетаданных",
			ПараметрыФормы,,,,,	ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПользователяСтандартногоИнтерфейсаODataПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Функция Сохранить(Команда = Неопределено)
	
	ОчиститьСообщения();
	
	Если Не Модифицированность Тогда
		Возврат Истина;
	КонецЕсли;
		
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СохранитьНаСервере();
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда = Неопределено)
	
	Если Сохранить() Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМетаданные(Команда)
	
	Если Модифицированность
		И ОбъектыМетаданных.ПолучитьЭлементы().Количество() > 0 Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьМетаданныеПродолжение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Загрузить метаданные заново? Внесенные изменения будут потеряны.'"), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ЗагрузитьМетаданныеПродолжение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьМетаданныеПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ЗапуститьПодготовкуПараметровНастройки();
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	Если ТипЗнч(Результат) = Тип("Структура") 
		И Результат.Статус <> "Выполнено" Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗавершениеПолученияПараметровНастройки", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, Оповещение, ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗакрытиеПослеВопроса(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Результат - КодВозвратаДиалога
//             - Неопределено
//   Контекст  - Структура
//
&НаКлиенте
Процедура ОбъектыМетаданныхИспользованиеПриИзмененииПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УстановитьИспользованиеЗависимостей(Контекст.Зависимости, Контекст.Добавление);
	Иначе
		Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование = Не Элементы.ОбъектыМетаданных.ТекущиеДанные.Использование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПолученияПараметровНастройки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Результат.Статус <> "Выполнено" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	АдресХранилища = Результат.АдресРезультата;
	ЗагрузитьПараметрыНастройки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Элементы.ИмяПользователяИПароль.Доступность = СоздатьПользователяСтандартногоИнтерфейсаOData;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Использование = Истина;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ОбъектыМетаданныхИспользование");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбъектыМетаданных.Корневой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
КонецПроцедуры

&НаСервере
Функция ЗависимостиДляДобавленияОбъекта(Знач ИдентификаторСтроки)
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиДляДобавления");
	Возврат ЗависимостиДляОбъекта(ИдентификаторСтроки, ТаблицаЗависимостей, Истина);
	
КонецФункции

&НаСервере
Функция ЗависимостиДляУдаленияОбъекта(Знач ИдентификаторСтроки)
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиДляУдаления");
	Возврат ЗависимостиДляОбъекта(ИдентификаторСтроки, ТаблицаЗависимостей, Ложь);
	
КонецФункции

&НаСервере
Функция ЗависимостиДляОбъекта(Знач ИдентификаторСтроки, ТаблицаЗависимостей, ИспользованиеЭталон)
	
	Результат = Новый Массив();
	
	ИмяТекущегоОбъекта = ОбъектыМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки).ПолноеИмя;
	
	ДеревоОбъектов = РеквизитФормыВЗначение("ОбъектыМетаданных");
	
	ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, ИмяТекущегоОбъекта, ИспользованиеЭталон);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, ИмяТекущегоОбъекта, ИспользованиеЭталон)
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ИмяОбъекта", ИмяТекущегоОбъекта);
	
	СтрокиЗависимостей = ТаблицаЗависимостей.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаЗависимости Из СтрокиЗависимостей Цикл
		
		ЗависимыйОбъектВДереве = ДеревоОбъектов.Строки.Найти(СтрокаЗависимости.ИмяЗависимогоОбъекта, "ПолноеИмя", Истина);
		
		Если ЗависимыйОбъектВДереве.Использование <> ИспользованиеЭталон И Результат.Найти(СтрокаЗависимости.ИмяЗависимогоОбъекта) = Неопределено Тогда
			
			Результат.Добавить(СтрокаЗависимости.ИмяЗависимогоОбъекта);
			ЗаполнитьТребуемыеЗависимостиОбъектаПоСтроке(Результат, ДеревоОбъектов, ТаблицаЗависимостей, 
				СтрокаЗависимости.ИмяЗависимогоОбъекта, ИспользованиеЭталон);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеЗависимостей(Знач Зависимости, Знач Использование)
	
	КорневыеЭлементы = ОбъектыМетаданных.ПолучитьЭлементы();
	Для Каждого КорневойЭлемент Из КорневыеЭлементы Цикл
		
		ЭлементыДерева = КорневойЭлемент.ПолучитьЭлементы();
		Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
			
			Если Зависимости.Найти(ЭлементДерева.ПолноеИмя) <> Неопределено Тогда
				ЭлементДерева.Использование = Использование;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	НачатьТранзакцию();
	
	Попытка
		
		Настройки = Новый Структура();
		
		Настройки.Вставить("Используется", СоздатьПользователяСтандартногоИнтерфейсаOData);
		Настройки.Вставить("Логин", ИмяПользователя);
		Если ПроверкаИзмененияПароля <> Пароль Тогда
			Настройки.Вставить("Пароль", Пароль);
		КонецЕсли;
		
		Обработки.НастройкаСтандартногоИнтерфейсаOData.ЗаписатьНастройкиАвторизацииДляСтандартногоИнтерфейсаOData(Настройки);
		
		Состав = Новый Массив();
		Дерево = РеквизитФормыВЗначение("ОбъектыМетаданных");
		Строки = Дерево.Строки.НайтиСтроки(Новый Структура("Использование", Истина), Истина);
		Для Каждого Строка Из Строки Цикл
			Состав.Добавить(Строка.ПолноеИмя);
		КонецЦикла;
		
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме("УстановитьСоставСтандартногоИнтерфейсаOData(Параметры);", Состав);
		
		Модифицированность = Ложь;
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПараметрыНастройки()
	
	Данные = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Данные.ДеревоОбъектов, "ОбъектыМетаданных");
	ЗначениеВРеквизитФормы(Данные.ЗависимостиДобавления, "ЗависимостиДляДобавления");
	ЗначениеВРеквизитФормы(Данные.ЗависимостиУдаления, "ЗависимостиДляУдаления");
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьПодготовкуПараметровНастройки()
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = "ПодготовитьПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData";
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.НастройкаСтандартногоИнтерфейсаOData.ПодготовитьПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData",
		Новый Структура,
		ПараметрыВыполненияВФоне);
	
	АдресХранилища = Результат.АдресРезультата;
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьПараметрыНастройки();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


