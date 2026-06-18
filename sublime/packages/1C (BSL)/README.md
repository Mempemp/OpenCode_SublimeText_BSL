*For English please scroll down*

# Поддержка языка 1С:Предприятие 8 (BSL) в Sublime Text

[![Join the chat at https://gitter.im/xDrivenDevelopment/1c-syntax](https://badges.gitter.im/xDrivenDevelopment/1c-syntax.svg)](https://gitter.im/xDrivenDevelopment/1c-syntax?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Добавляет подсветку встроенного языка 1С:Предпрятие 8 файлам \*.bsl и \*.os - синтаксис `1C (BSL)`.  
Добавляет подсветку текста запросов языка запросов 1С: внутри текста модуля или отдельно - синтаксис `1C (Query)`.

### Дополнительные возможности

* Список процедур и функций текущего файла/проекта - [инструкция](https://github.com/xDrivenDevelopment/sublime-language-1c-bsl/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80-%D0%B8-%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D0%B9)
* Переход к определению процедур и функций по нажатию <kbd>F12</kbd>
* Автодополнение процедур и функций глобального контекста
* Сниппеты (шаблоны текста)
* Использование автоматических отступов по ключевым словам
* Автоматическое добавление символа `|` при добавлении новой строки во время редактирования строкового литерала
* Запуск скриптов `.os`/`.bsl` с помощью OneScript - [инструкция](https://github.com/xDrivenDevelopment/sublime-language-1c-bsl/wiki/%D0%97%D0%B0%D0%BF%D1%83%D1%81%D0%BA-%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82%D0%BE%D0%B2-.os-.bsl-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-OneScript)
* Проверка корректности кода в файлах `*.os` и `*.bsl` (опционально) через интерпретатор OneScript - [инструкция](https://github.com/xDrivenDevelopment/sublime-language-1c-bsl/wiki/%D0%98%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BB%D0%B8%D0%BD%D1%82%D0%B5%D1%80%D0%B0)

Установка
---------

***Через Package Control***

Самый быстрый и простой способ установить этот пакет для Sublime Text:

1. Установить [Package Control](https://packagecontrol.io/installation)
2. Открыть `Tools` → `Command Palette`
3. Выбрать `Package Control: Install Package`
4. Указать в поиске пакет `Language 1C (BSL)` и установить его

***Установка значений по умолчанию***

После того, как вы успешно установили пакет поддержки языка, все что вам остается
сделать это указать, что файлы `*.bsl` и `*.os` всегда должны открываться с
указанной подсветкой синтаксиса. Перейдите

`View` → `Syntax` → `Open all with current extension as...` → `1C (BSL)`

Вы всегда сможете изменить эту настройку.

***Ручная установка***

Скачайте файл `tmLanguage` из этого репозитория. Перейдите в вашу папку
`Packages`, создайте внутри папку `language-1c-bsl` и скопируйте туда файл
`tmLanguage`

Сотрудничество
----------

Сотрудничество крайне приветствуется. Разработка грамматик ведется в родительском репозитории [xDrivenDevelopment/1c-syntax](https://github.com/xDrivenDevelopment/1c-syntax).

# 1С:Enterprise 8 (BSL) language support in Sublime Text

Adds syntax highlighting to \*.bsl и \*.os files in Sublime Text.

Installation
------------

***Via Package Control***

The fastest and easiest way to install these packages for Sublime Text is the
following:

1. Install [Package Control](https://packagecontrol.io/installation)
2. Open `Tools` → `Command Palette`
3. Select `Package Control: Install Package`
4. Search for `Language 1C (BSL)` packages and install it

***Set as default***

After you installed the language definition file successfully, all you have to
do is assign the `*.bsl` и `*.os` files to always open with this syntax highlighter.
Go to

`View` → `Syntax` → `Open all with current extension as...` → `1C (BSL)`

To remove this setting, you can always overwrite this preference.

***Manual installation***

Download the `tmLanguage` file from this repository. 
Navigate to your `Packages` folder and create a `language-1c-bsl` and copy the
`tmLanguage` file into.

Contribute
----------

Contributions are greatly appreciated. Development is carried in a parent repository [xDrivenDevelopment/1c-syntax](https://github.com/xDrivenDevelopment/1c-syntax)

![st](https://cloud.githubusercontent.com/assets/1132840/12221775/e1e22810-b7b9-11e5-9d02-8c707b5d14fc.PNG)

![query-st](https://cloud.githubusercontent.com/assets/1132840/13007620/9e72c334-d1a2-11e5-8b22-b81e1abb264c.PNG)
