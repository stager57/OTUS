﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
Функция ПодключитьНапоминаниеДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита, ПовторятьЕжегодно = Ложь) Экспорт
	
	Возврат НапоминанияПользователяСлужебный.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, ПовторятьЕжегодно);
	
КонецФункции

Функция ПодключитьНапоминание(Текст, ВремяСобытия, ИнтервалДоСобытия = 0, Предмет = Неопределено, Идентификатор = Неопределено) Экспорт
	
	Возврат НапоминанияПользователяСлужебный.ПодключитьПроизвольноеНапоминание(
		Текст, ВремяСобытия, ИнтервалДоСобытия, Предмет, Идентификатор);
	
КонецФункции

#КонецОбласти
