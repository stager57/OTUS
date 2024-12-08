﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Подставляет в шаблон переданные параметры.
//
// Параметры:
//   Шаблон - Строка - исходный шаблон. Например "Добрый день, [ФИО]".
//   Параметры - Структура:
//      * Ключ - Строка - имя параметра. Например "ФИО".
//      * Значение - Произвольный - строка подстановки. Например "Иванов Иван Иванович".
//
// Возвращаемое значение: 
//   Строка
//
Функция ЗаполнитьШаблон(Шаблон, Параметры) Экспорт
	НачалоПараметра = "["; 
	КонецПараметра = "]";
	НачалоФормата = "("; 
	КонецФормата = ")"; 
	ВырезатьОбрамление = Истина; // отладочный параметр
	
	Результат = Шаблон;
	Для Каждого КлючИЗначение Из Параметры Цикл
		// Замена "[ключ]" на "значение".
		Результат = СтрЗаменить(
			Результат,
			НачалоПараметра + КлючИЗначение.Ключ + КонецПараметра, 
			?(ВырезатьОбрамление, "", НачалоПараметра) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", КонецПараметра));
		ДлинаФорматЛевый = СтрДлина(НачалоПараметра + КлючИЗначение.Ключ + НачалоФормата);
		// Замена "[ключ(формат)]" на "значение в формате".
		Позиция1 = СтрНайти(Результат, НачалоПараметра + КлючИЗначение.Ключ + НачалоФормата);
		Пока Позиция1 > 0 Цикл
			Позиция2 = СтрНайти(Результат, КонецФормата + КонецПараметра);
			Если Позиция2 = 0 Тогда
				Прервать;
			КонецЕсли;
			ФорматнаяСтрока = Сред(Результат, Позиция1 + ДлинаФорматЛевый, Позиция2 - Позиция1 - ДлинаФорматЛевый);
			Попытка
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", НачалоПараметра) + Формат(КлючИЗначение.Значение, ФорматнаяСтрока) + ?(ВырезатьОбрамление, "", КонецПараметра);
			Исключение
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", НачалоПараметра) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", КонецПараметра);
			КонецПопытки;
			Результат = СтрЗаменить(
				Результат,
				НачалоПараметра + КлючИЗначение.Ключ + НачалоФормата + ФорматнаяСтрока + КонецФормата + КонецПараметра, 
				НаЧтоЗаменить);
			Позиция1 = СтрНайти(Результат, НачалоПараметра + КлючИЗначение.Ключ + НачалоФормата);
		КонецЦикла;
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Формирует представление способов доставки в соответствии с параметрами доставки.
//
// Параметры:
//   ПараметрыДоставки - см. ВыполнитьРассылку.ПараметрыДоставки.
//
// Возвращаемое значение:
//   Строка
//
Функция ПредставлениеСпособовДоставки(ПараметрыДоставки) Экспорт
	Префикс = НСтр("ru = 'Результат'");
	ТекстПредставления = "";
	Суффикс = "";
	
	Если Не ПараметрыДоставки.ТолькоУведомить Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'отправлен по почте (см. вложения)'");
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаВПапку Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен в папку'")
		+ " ";
		
		Ссылка = ПолучитьНавигационнуюСсылкуИнформационнойБазы() +"#"+ ПолучитьНавигационнуюСсылку(ПараметрыДоставки.Папка);
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ Ссылка
			+ "'>" 
			+ Строка(ПараметрыДоставки.Папка)
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ """"
			+ Строка(ПараметрыДоставки.Папка)
			+ """";
			Суффикс = Суффикс + ":" + Символы.ПС + "<" + Ссылка + ">";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаВСетевойКаталог Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен в сетевой каталог'")
		+ " ";
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ "'>" 
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ "<"
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ ">";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаНаFTP Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен на FTP ресурс'")
		+ " ";
		
		Ссылка = "ftp://"
		+ ПараметрыДоставки.Сервер 
		+ ":"
		+ Формат(ПараметрыДоставки.Порт, "ЧН=0; ЧГ=0") 
		+ ПараметрыДоставки.Каталог;
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ Ссылка
			+ "'>" 
			+ Ссылка
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ "<"
			+ Ссылка
			+ ">";
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстПредставления = ТекстПредставления + ?(Суффикс = "", ".", Суффикс);
	
	Возврат ТекстПредставления;
КонецФункции

Функция ПредставлениеСписка(Коллекция, ИмяКолонки = "", МаксимумСимволов = 60) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Всего", 0);
	Результат.Вставить("ДлинаПолного", 0);
	Результат.Вставить("ДлинаКраткого", 0);
	Результат.Вставить("Краткое", "");
	Результат.Вставить("Полное", "");
	Результат.Вставить("МаксимумПревышен", Ложь);
	Для Каждого Объект Из Коллекция Цикл
		ПредставлениеЗначения = Строка(?(ИмяКолонки = "", Объект, Объект[ИмяКолонки]));
		Если ПустаяСтрока(ПредставлениеЗначения) Тогда
			Продолжить;
		КонецЕсли;
		Если Результат.Всего = 0 Тогда
			Результат.Всего        = 1;
			Результат.Полное       = ПредставлениеЗначения;
			Результат.ДлинаПолного = СтрДлина(ПредставлениеЗначения);
		Иначе
			Полное       = Результат.Полное + ", " + ПредставлениеЗначения;
			ДлинаПолного = Результат.ДлинаПолного + 2 + СтрДлина(ПредставлениеЗначения);
			Если Не Результат.МаксимумПревышен И ДлинаПолного > МаксимумСимволов Тогда
				Результат.Краткое          = Результат.Полное;
				Результат.ДлинаКраткого    = Результат.ДлинаПолного;
				Результат.МаксимумПревышен = Истина;
			КонецЕсли;
			Результат.Всего        = Результат.Всего + 1;
			Результат.Полное       = Полное;
			Результат.ДлинаПолного = ДлинаПолного;
		КонецЕсли;
	КонецЦикла;
	Если Результат.Всего > 0 И Не Результат.МаксимумПревышен Тогда
		Результат.Краткое       = Результат.Полное;
		Результат.ДлинаКраткого = Результат.ДлинаПолного;
		Результат.МаксимумПревышен = Результат.ДлинаПолного > МаксимумСимволов;
	КонецЕсли;
	Возврат Результат;
КонецФункции

#КонецОбласти
