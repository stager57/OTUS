﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Задает вопрос о продолжении действия, влекущего к потере изменений.
//
Процедура ПодтвердитьЗакрытиеФормыСейчас() Экспорт
	
	ОбщегоНазначенияСлужебныйКлиент.ПодтвердитьЗакрытиеФормы();
	
КонецПроцедуры

// Задает вопрос о продолжении действия, ведущего к закрытию формы.
//
Процедура ПодтвердитьЗакрытиеПроизвольнойФормыСейчас() Экспорт
	
	ОбщегоНазначенияСлужебныйКлиент.ПодтвердитьЗакрытиеПроизвольнойФормы();
	
КонецПроцедуры

#КонецОбласти
