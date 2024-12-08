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
	
	Если НЕ Параметры.Свойство("Письмо") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗапрещенныеРасширения = РаботаСФайламиСлужебный.СписокЗапрещенныхРасширений();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,Параметры,, "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, ТолькоПросмотр");
	Письмо = Параметры.Письмо;
	
	Элементы.ГруппаПисьмоОснованиеПечать.Видимость = НеВызыватьКомандуПечати;
	
	УстановитьТекстПисьмаHTML(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьЗаголовокФормы(Письмо);
	СформироватьСтрокуПисьмаОснования();
	
	Если Вложения.Количество() > 0 И ОтображатьВложенияПисьма Тогда
		Элементы.Вложения.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстHTMLДокументСформирован(Элемент)
	
	Если Не НеВызыватьКомандуПечати 
		И Не ФормаДиалогаПечатиПриОткрытииОткрывалась Тогда
		Элементы.ТекстHTML.Документ.execCommand("Print");
		ФормаДиалогаПечатиПриОткрытииОткрывалась = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПисьмоОснованиеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьВложение"
		И ПисьмоОснование <> Неопределено Тогда
		
		ПоказатьЗначение(, ПисьмоОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеОНебезопасномСодержимомОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВключитьНебезопасноеСодержимое" Тогда
		СтандартнаяОбработка = Ложь;
		ВключитьНебезопасноеСодержимое = Истина;
		УстановитьТекстПисьмаHTML();;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложениеПисьма();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Элементы.ТекстHTML.Документ.execCommand("Print");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложение(Команда)
	
	ОткрытьВложениеПисьма();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложение(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЧастиИмениФайла = НаименованиеИРасширениеФайлаПоИмениФайла(ТекущиеДанные.ИмяФайла);
	
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",        ТекущиеДанные.АдресВоВременномХранилище);
	ДанныеФайла.Вставить("ОтносительныйПуть",                  "");
	ДанныеФайла.Вставить("ДатаМодификацииУниверсальная",       "");
	ДанныеФайла.Вставить("ИмяФайла",                           ТекущиеДанные.ИмяФайла);
	ДанныеФайла.Вставить("Наименование",                       ЧастиИмениФайла.Наименование);
	ДанныеФайла.Вставить("Расширение",                         ЧастиИмениФайла.Расширение);
	ДанныеФайла.Вставить("Размер",                             ТекущиеДанные.Размер);
	ДанныеФайла.Вставить("Редактирует",                        Неопределено);
	ДанныеФайла.Вставить("ПодписанЭП",                         Ложь);
	ДанныеФайла.Вставить("Зашифрован",                         Ложь);
	ДанныеФайла.Вставить("ФайлРедактируется",                  Ложь);
	ДанныеФайла.Вставить("ФайлРедактируетТекущийПользователь", Ложь);
	
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьВложениеПисьма()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоВложениеПисьмо Тогда
		ВзаимодействияКлиент.ОткрытьВложениеПисьмо(ТекущиеДанные.АдресВоВременномХранилище, ПараметрыОткрытияПисьмаВложения(), ЭтотОбъект);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		Если ВзаимодействияКлиент.ЯвляетсяЭлектроннымПисьмом(ТекущиеДанные.Ссылка)
			Или ВзаимодействияКлиентСервер.ЭтоФайлПисьмо(ТекущиеДанные.ИмяФайла) Тогда
			ВзаимодействияКлиент.ОткрытьВложениеПисьмо(ТекущиеДанные.Ссылка, ПараметрыОткрытияПисьмаВложения(), ЭтотОбъект);
		Иначе
			УправлениеЭлектроннойПочтойКлиент.ОткрытьВложение(ТекущиеДанные.Ссылка, ЭтотОбъект);
		КонецЕсли;
		
	Иначе
		ФайловаяСистемаКлиент.ОткрытьФайл(ТекущиеДанные.АдресВоВременномХранилище);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПустаяТаблицаПолучатели()

	ОписаниеТипаСтроки = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100));
	
	ТаблицаПолучатели = Новый ТаблицаЗначений();
	ТаблицаПолучатели.Колонки.Добавить("Адрес", ОписаниеТипаСтроки);
	ТаблицаПолучатели.Колонки.Добавить("Представление", ОписаниеТипаСтроки);
	
	Возврат ТаблицаПолучатели;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВложенияИСФормироватьТекстHTMLНаОснованииПисьмаВложения(ПисьмоВложение)
	
	Вложения.Очистить();
	ВложенияСИдентификаторами.Очистить();
	
	ПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	
	Если ЭтоАдресВременногоХранилища(ПисьмоВложение) Тогда
		ИсходныеДанные = ПолучитьИзВременногоХранилища(ПисьмоВложение);
	Иначе
		ИсходныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ПисьмоВложение);
	КонецЕсли;
	
	ПочтовоеСообщение.УстановитьИсходныеДанные(ИсходныеДанные);
	
	Если ПочтовоеСообщение.СтатусРазбора = СтатусРазбораИнтернетПочтовогоСообщения.ОбнаруженыОшибки Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось разобрать почтовое сообщение.'"));
		Возврат;
	КонецЕсли;
	
	ПолучателиПисьма = ПустаяТаблицаПолучатели();
	УправлениеЭлектроннойПочтой.ЗаполнитьИнтернетПочтовыеАдреса(ПолучателиПисьма, ПочтовоеСообщение.Получатели);
	ПолучателиКопий  = ПустаяТаблицаПолучатели();
	УправлениеЭлектроннойПочтой.ЗаполнитьИнтернетПочтовыеАдреса(ПолучателиКопий, ПочтовоеСообщение.Получатели);
	
	СтруктураПисьмо = Новый Структура("ТипТекста, ТекстHTML, Текст");
	СтруктураПисьмо.Вставить("Кодировка",                    ПочтовоеСообщение.Кодировка);
	СтруктураПисьмо.Вставить("ОтправительПредставление",     ПочтовоеСообщение.ИмяОтправителя);
	СтруктураПисьмо.Вставить("ОтправительАдрес",             ПочтовоеСообщение.Отправитель.Адрес);
	СтруктураПисьмо.Вставить("Дата",                         ПочтовоеСообщение.ДатаОтправления);
	СтруктураПисьмо.Вставить("Тема",                         ПочтовоеСообщение.Тема);
	СтруктураПисьмо.Вставить("ПолучателиПисьма",             ПолучателиПисьма);
	СтруктураПисьмо.Вставить("ПолучателиКопий",              ПолучателиКопий);
	ИмяПользователяУчетнойЗаписи = ?(ПустаяСтрока(ИмяПользователяУчетнойЗаписи),
	                                 ИмяПользователяУчетнойЗаписиПисьмаПоВложению(ПисьмоВложение),
	                                 ИмяПользователяУчетнойЗаписи);
	СтруктураПисьмо.Вставить("ИмяПользователяУчетнойЗаписи", ИмяПользователяУчетнойЗаписи);
	
	ТемаПисьма = ПочтовоеСообщение.Тема;
	ДатаПисьма = ПочтовоеСообщение.ДатаОтправления;
	
	Для Каждого Вложение Из ПочтовоеСообщение.Вложения Цикл
		
		Если НЕ ПустаяСтрока(Вложение.Идентификатор) 
			И СтрНайти(СтруктураПисьмо.ТекстHTML, Вложение.Имя) = 0 Тогда
			
			НоваяСтрока = ВложенияСИдентификаторами.Добавить();
			НоваяСтрока.Наименование              = Вложение.ИмяФайла;
			НоваяСтрока.Ссылка                    = ПоместитьВоВременноеХранилище(Вложение.Данные, УникальныйИдентификатор);
			НоваяСтрока.ИДФайлаЭлектронногоПисьма = Вложение.Идентификатор;
			НоваяСтрока.Расширение                = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(Вложение.ИмяФайла);
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрока = Вложения.Добавить();
		НоваяСтрока.ИмяФайла = Вложение.ИмяФайла;
		Расширение = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(НоваяСтрока.ИмяФайла);
		Если ТипЗнч(Вложение.Данные) = Тип("ДвоичныеДанные") Тогда
			
			НоваяСтрока.ИндексКартинки    = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
			ДанныеВложения                = Вложение.Данные;
			НоваяСтрока.ЭтоВложениеПисьмо = УправлениеЭлектроннойПочтой.ФайлЯвляетсяЭлектроннымПисьмом(НоваяСтрока.ИмяФайла, ДанныеВложения);
			
		Иначе
			
			ДанныеВложения                = Вложение.Данные.ПолучитьИсходныеДанные();
			НоваяСтрока.ИмяФайла          = Вложение.Данные.Тема + ".eml";
			НоваяСтрока.ИндексКартинки    = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла("eml");
			НоваяСтрока.ЭтоВложениеПисьмо = Истина;
			
		КонецЕсли;
		
		НоваяСтрока.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеВложения, УникальныйИдентификатор);
		НоваяСтрока.РазмерПредставление       = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(ДанныеВложения.Размер());
		
	КонецЦикла;
	
	СтруктураПисьмо.Вставить("Вложения", ВложенияСИдентификаторами);
	
	УправлениеЭлектроннойПочтой.УстановитьТекстПисьма(СтруктураПисьмо, ПочтовоеСообщение);
	
	ПараметрыФормирования = Взаимодействия.ПараметрыФормированияДокументаHTMLНаОснованииПисьма(СтруктураПисьмо);
	ПараметрыФормирования.Письмо = СтруктураПисьмо;
	ПараметрыФормирования.ОтключитьВнешниеРесурсы = Не ВключитьНебезопасноеСодержимое;
	
	ДокументHTML = Взаимодействия.СформироватьДокументHTMLНаОснованииПисьма(ПараметрыФормирования, ЕстьНебезопасноеСодержимое);
	
	Взаимодействия.ДополнитьТелоПисьмаШапкойПечатнойФормы(ДокументHTML, СтруктураПисьмо, Истина);
	
	Если Вложения.Количество() > 0 Тогда
		Взаимодействия.ДополнитьТелоПисьмаПодваломВложения(ДокументHTML, Вложения);
	КонецЕсли;
	
	ТекстHTML = Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	
КонецПроцедуры

&НаСервере
Функция ИмяПользователяУчетнойЗаписиПисьмаПоВложению(ПисьмоВложение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.ИмяПользователя КАК ИмяПользователя,
	|	УчетныеЗаписиЭлектроннойПочты.Наименование
	|ИЗ
	|	Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы КАК ПрисоединенныеФайлыПисьма
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмо
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|			ПО ЭлектронноеПисьмо.УчетнаяЗапись = УчетныеЗаписиЭлектроннойПочты.Ссылка
	|		ПО ПрисоединенныеФайлыПисьма.ВладелецФайла = ЭлектронноеПисьмо.Ссылка
	|ГДЕ
	|	ПрисоединенныеФайлыПисьма.Ссылка = &Вложение";
	
	Если ТипЗнч(ПисьмоВложение) = Тип("СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы") Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
		                           "Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы",
		                           "Справочник.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
		                           "Документ.ЭлектронноеПисьмоВходящее", 
		                           "Документ.ЭлектронноеПисьмоИсходящее");
		
	ИначеЕсли  ТипЗнч(ПисьмоВложение) <> Тип("СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы") Тогда
		Возврат "";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Вложение", ПисьмоВложение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат ?(ПустаяСтрока(Выборка.ИмяПользователя), Выборка.Наименование, Выборка.ИмяПользователя);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура СформироватьТаблицуВложенийДляХранимогоПисьма(Письмо)

	Если Не ОтображатьВложенияПисьма Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВложения = УправлениеЭлектроннойПочтой.ПолучитьВложенияЭлектронногоПисьма(Письмо, Истина, Истина);
	Для Каждого СтрокаТаблицыВложений Из ТаблицаВложения Цикл
		Если ПустаяСтрока(СтрокаТаблицыВложений.ИДФайлаЭлектронногоПисьма) Тогда
			НоваяСтрока = Вложения.Добавить();
			НоваяСтрока.Ссылка              = СтрокаТаблицыВложений.Ссылка;
			НоваяСтрока.ИмяФайла            = СтрокаТаблицыВложений.ИмяФайла;
			НоваяСтрока.ИндексКартинки      = СтрокаТаблицыВложений.ИндексКартинки;
			НоваяСтрока.Размер              = СтрокаТаблицыВложений.Размер;
			НоваяСтрока.РазмерПредставление = СтрокаТаблицыВложений.РазмерПредставление;
		КонецЕсли;
	КонецЦикла;
	
	Если ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		
		ТаблицаПисемВложений = Взаимодействия.ДанныеХранимыхВБазеПисемВложений(Письмо);
		
		Для Каждого ПисьмоВложение Из ТаблицаПисемВложений Цикл
			
			ПредставлениеПисьма = Взаимодействия.ПредставлениеПисьма(ПисьмоВложение.Тема, ПисьмоВложение.Дата);
			
			НоваяСтрока = Вложения.Добавить();
			НоваяСтрока.Ссылка               = ПисьмоВложение.Письмо;
			НоваяСтрока.ИмяФайла             = ПредставлениеПисьма;
			НоваяСтрока.ИндексКартинки       = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла("eml");
			НоваяСтрока.ПодписанЭП           = Ложь;
			НоваяСтрока.Размер               = ПисьмоВложение.Размер;
			НоваяСтрока.РазмерПредставление  = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(НоваяСтрока.Размер)
			
		КонецЦикла;
		
	КонецЕсли;

	
	Вложения.Сортировать("ИмяФайла");

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы(Письмо)

	Если НЕ НеВызыватьКомандуПечати Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		
		РеквизитыПисьма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Письмо, "ДатаПолучения, Тема");
		ТемаПисьма = РеквизитыПисьма.Тема;
		ДатаПисьма = РеквизитыПисьма.ДатаПолучения;
		
	ИначеЕсли ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		
		РеквизитыПисьма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Письмо, "ДатаОтправления, Дата , Тема");
		ТемаПисьма = РеквизитыПисьма.Тема;
		ДатаПисьма = ?(ЗначениеЗаполнено(РеквизитыПисьма.ДатаОтправления), РеквизитыПисьма.ДатаОтправления, РеквизитыПисьма.Дата);
		
	КонецЕсли;
	
	Заголовок = Взаимодействия.ПредставлениеПисьма(ТемаПисьма, ДатаПисьма);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОткрытияПисьмаВложения()

	ПараметрыВложения = ВзаимодействияКлиент.ПустаяСтруктураПараметровПисьмаВложения();
	ПараметрыВложения.ДатаПисьмаОснования = ДатаПисьма;
	ПараметрыВложения.ТемаПисьмаОснования = ТемаПисьма;
	
	Возврат ПараметрыВложения;

КонецФункции

&НаСервере
Процедура СформироватьСтрокуПисьмаОснования();

	Если НЕ НеВызыватьКомандуПечати Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаголовокСтроки = Новый ФорматированнаяСтрока(НСтр("ru = 'Вложение к письму:'"));
	ПредставлениеПисьма = Взаимодействия.ПредставлениеПисьма( ТемаПисьмаОснования, ДатаПисьмаОснования);
	Если ПисьмоОснование = Неопределено Тогда
		ТекстСтроки = Новый ФорматированнаяСтрока(ПредставлениеПисьма);
	Иначе
		ТекстСтроки = Новый ФорматированнаяСтрока(ПредставлениеПисьма, ,
			ЦветаСтиля.ГиперссылкаЦвет, , "ОткрытьВложение");
	КонецЕсли;

	Элементы.ДекорацияПисьмоОснование.Заголовок = Новый ФорматированнаяСтрока(ЗаголовокСтроки, " ", ТекстСтроки);
	
КонецПроцедуры

&НаКлиенте
Функция НаименованиеИРасширениеФайлаПоИмениФайла(Знач ИмяФайла)
	
	Результат = Новый Структура;
	Результат.Вставить("Расширение",   "");
	Результат.Вставить("Наименование", "");
	
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		
		Результат.Расширение   = МассивСтрок[МассивСтрок.Количество() - 1];
		Результат.Наименование = Лев(ИмяФайла, СтрДлина(ИмяФайла) - СтрДлина(Результат.Расширение) - 1);
	Иначе
		Результат.Наименование = ИмяФайла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьПредупрежденияБезопасности()
	ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах = Взаимодействия.ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах();
	Элементы.ПредупреждениеБезопасности.Видимость = Не ЗапрещеноОтображениеНебезопасногоСодержимогоВПисьмах
		И ЕстьНебезопасноеСодержимое И Не ВключитьНебезопасноеСодержимое;
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПисьмаHTML(Отказ = Неопределено)
	
	Если ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		
		ТекстHTML = Взаимодействия.СформироватьТекстHTMLДляВходящегоПисьма(Письмо, Истина, Ложь, Не ВключитьНебезопасноеСодержимое, ЕстьНебезопасноеСодержимое);
		СформироватьТаблицуВложенийДляХранимогоПисьма(Письмо);
		
	ИначеЕсли ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		
		ТекстHTML = Взаимодействия.СформироватьТекстHTMLДляИсходящегоПисьма(Письмо, Истина, Ложь, Не ВключитьНебезопасноеСодержимое, ЕстьНебезопасноеСодержимое);
		СформироватьТаблицуВложенийДляХранимогоПисьма(Письмо);
		
	ИначеЕсли ТипЗнч(Письмо) = Тип("СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы")
		     Или ТипЗнч(Письмо) = Тип("СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы")
		     Или ЭтоАдресВременногоХранилища(Письмо) Тогда
		
		ЗаполнитьВложенияИСФормироватьТекстHTMLНаОснованииПисьмаВложения(Письмо);
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	УстановитьВидимостьПредупрежденияБезопасности();
	
КонецПроцедуры

#КонецОбласти
