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
	
	ИдентификаторПроверки = Параметры.ИдентификаторПроверки;
	
	Если ИдентификаторПроверки = "СтандартныеПодсистемы.ПроверкаЦиклическихСсылок" Тогда
		ТекстВопроса = НСтр("ru = 'Исправление циклических ссылок может занять продолжительное время. Выполнить исправление?'");
	ИначеЕсли ИдентификаторПроверки = "СтандартныеПодсистемы.ПроверкаОтсутствующихПредопределенныхЭлементов" Тогда
		ТекстВопроса = НСтр("ru = 'Создать отсутствующие предопределенные элементы заново?'");
	КонецЕсли;
	
	Элементы.НадписьВопрос.Заголовок = ТекстВопроса;
	УстановитьТекущуюСтраницу(ЭтотОбъект, "Вопрос");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсправитьПроблему(Команда)
	
	Если ИдентификаторПроверки = "СтандартныеПодсистемы.ПроверкаЦиклическихСсылок" Тогда
		ДлительнаяОперация = ИсправитьПроблемуВФоне(ИдентификаторПроверки);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ИсправитьПроблемуВФонеЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	ИначеЕсли ИдентификаторПроверки = "СтандартныеПодсистемы.ПроверкаОтсутствующихПредопределенныхЭлементов" Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
		ВосстановитьОтсутствующиеПредопределенныеЭлементы(ИдентификаторПроверки);
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИсправлениеУспешноВыполнено");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницу(Форма, ИмяСтраницы)
	
	ЭлементыФормы = Форма.Элементы;
	Если ИмяСтраницы = "ИдетИсправлениеПроблемы" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Истина;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
	ИначеЕсли ИмяСтраницы = "ИсправлениеУспешноВыполнено" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Истина;
	Иначе // "Вопрос"
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Истина;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИсправитьПроблемуВФоне(ИдентификаторПроверки)
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Исправление циклических ссылок'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("КонтрольВеденияУчетаСлужебный.ИсправитьПроблемуЦиклическихСсылокВФоновомЗадании",
		Новый Структура("ИдентификаторПроверки", ИдентификаторПроверки), ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ИсправитьПроблемуВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперация = Неопределено;

	Если Результат = Неопределено Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "Вопрос");
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИсправлениеУспешноВыполнено");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВосстановитьОтсутствующиеПредопределенныеЭлементы(ИдентификаторПроверки) 
	
	// 1. Пытаемся найти имеющийся элемент, похожий на предопределенный и привязать его.
	Результат = ПравилоПроверкиПоИдентификатору(ИдентификаторПроверки);
	ПравилоПроверки = Результат.Ссылка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПравилоПроверки", ПравилоПроверки);
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РезультатыПроверкиУчета.ПроблемныйОбъект КАК ПроблемныйОбъект
		|ИЗ
		|	РегистрСведений.РезультатыПроверкиУчета КАК РезультатыПроверкиУчета
		|ГДЕ
		|	РезультатыПроверкиУчета.ПравилоПроверки = &ПравилоПроверки";
	Результат = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	Для Каждого Строка Из Результат Цикл
		Идентификатор    = Строка.ПроблемныйОбъект;
		ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Идентификатор, Ложь);
		НетИерархии = ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных)
			           Или ОбщегоНазначения.ЭтоПланВидовРасчета(ОбъектМетаданных)
			           Или Не ОбъектМетаданных.Иерархический;
		
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ПсевдонимЗаданнойТаблицы.Ссылка КАК Ссылка,
			|	ЕСТЬNULL(ПсевдонимЗаданнойТаблицы.Родитель.ИмяПредопределенныхДанных, """") КАК ИмяРодителя,
			|	ПсевдонимЗаданнойТаблицы.ИмяПредопределенныхДанных КАК Имя
			|ИЗ
			|	&ТекущаяТаблица КАК ПсевдонимЗаданнойТаблицы
			|ГДЕ
			|	ПсевдонимЗаданнойТаблицы.Предопределенный";
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ТекущаяТаблица", ПолноеИмя);
		
		Если НетИерархии Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,
				"ЕСТЬNULL(ПсевдонимЗаданнойТаблицы.Родитель.ИмяПредопределенныхДанных, """")", """""");
		КонецЕсли;
		ТаблицаИмен = Запрос.Выполнить().Выгрузить();
		
		Если ТаблицаИмен.Количество() = 0 Тогда
			Продолжить; // Отсутствуют все предопределенные, восстановление штатным способом.
		КонецЕсли;
		ПредопределенныеВДанных     = ТаблицаИмен.ВыгрузитьКолонку("Имя");
		ПредопределенныеВМетаданных = Новый Массив(ОбъектМетаданных.ПолучитьИменаПредопределенных());
		
		Идентичны = ОбщегоНазначения.КоллекцииИдентичны(ПредопределенныеВДанных, ПредопределенныеВМетаданных);
		
		Если Идентичны Тогда
			Продолжить; // Все предопределенные есть в данных.
		КонецЕсли;
		
		Для Каждого ИмяЭлемента Из ПредопределенныеВДанных Цикл
			Индекс = ПредопределенныеВМетаданных.Найти(ИмяЭлемента);
			Если Индекс = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ПредопределенныеВМетаданных.Удалить(Индекс);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПсевдонимЗаданнойТаблицы.Ссылка КАК Ссылка,
			|	ЕСТЬNULL(ПсевдонимЗаданнойТаблицы.Родитель.ИмяПредопределенныхДанных, """") КАК ИмяРодителя,
			|	ПсевдонимЗаданнойТаблицы.Наименование КАК Наименование
			|ИЗ
			|	&ТекущаяТаблица КАК ПсевдонимЗаданнойТаблицы
			|ГДЕ
			|	НЕ ПсевдонимЗаданнойТаблицы.Предопределенный
			|	И ПсевдонимЗаданнойТаблицы.Родитель = &Родитель
			|	И ПсевдонимЗаданнойТаблицы.Наименование = &Наименование";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", ПолноеИмя);
		
		Если ПредопределенныеВМетаданных.Количество() > 0 Тогда
			Свойства = СвойстваОтсутствующихПредопределенных(ОбъектМетаданных, ТаблицаИмен, ПредопределенныеВМетаданных);
			Для Каждого Свойство Из Свойства Цикл
				Запрос.УстановитьПараметр("Наименование", Свойство.Наименование);
				Запрос.УстановитьПараметр("Родитель",     Свойство.Родитель);
				РезультатЗапроса = Запрос.Выполнить();
				Если РезультатЗапроса.Пустой() Тогда
					Продолжить;
				КонецЕсли;
				РезультатЗапроса = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"); // Массив из ЛюбаяСсылка
				Ссылка = РезультатЗапроса[0];
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(Ссылка.Метаданные().ПолноеИмя());
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
				
				НачатьТранзакцию();
				Попытка
					Блокировка.Заблокировать();
					
					Объект = Ссылка.ПолучитьОбъект();
					Объект.ИмяПредопределенныхДанных = Свойство.ИмяПредопределенныхДанных;
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
					
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					ВызватьИсключение;
				КонецПопытки;

			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// 2. Если не нашли элемент в данных, создаем предопределенный заново.
	СтандартныеПодсистемыСервер.ВосстановитьПредопределенныеЭлементы();
	
КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//   * Ссылка - СправочникСсылка.ПравилаПроверкиУчета
//
&НаСервереБезКонтекста
Функция ПравилоПроверкиПоИдентификатору( ИдентификаторПроверки)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторПроверки);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПравилаПроверкиУчета.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета
		|ГДЕ
		|	ПравилаПроверкиУчета.Идентификатор = &Идентификатор";
	Результат = Запрос.Выполнить().Выбрать();
	Результат.Следующий();
	Возврат Новый Структура("Ссылка", Результат.Ссылка);
КонецФункции

// Параметры:
//   ОбъектМетаданных - ОбъектМетаданных
//   ПредопределенныеВДанных - ТаблицаЗначений:
//   * Ссылка - ЛюбаяСсылка
//   Отсутствующие - Массив из ЛюбаяСсылка
// Возвращаемое значение:
//   Массив
//
&НаСервереБезКонтекста
Функция СвойстваОтсутствующихПредопределенных(ОбъектМетаданных, ПредопределенныеВДанных, Отсутствующие)
	Свойства = Новый Массив;
	НачатьТранзакцию();
	Попытка
		Для Каждого Строка Из ПредопределенныеВДанных Цикл
			Объект = Строка.Ссылка.ПолучитьОбъект();
			Объект.ИмяПредопределенныхДанных = "";
			// Конкурентной работы с некорректным предопределенным элементом не ожидается.
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект); // АПК:1327
		КонецЦикла;
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		Менеджер.УстановитьИнициализациюПредопределенныхДанных(Ложь);
		
		Для Каждого ИмяПредопределенного Из Отсутствующие Цикл
			НовыйПредопределенный = Менеджер[ИмяПредопределенного];
			Свойства.Добавить(ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НовыйПредопределенный, "Наименование, Родитель, ИмяПредопределенныхДанных"));
		КонецЦикла;
		ОтменитьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
	
	Возврат Свойства;
КонецФункции

#КонецОбласти