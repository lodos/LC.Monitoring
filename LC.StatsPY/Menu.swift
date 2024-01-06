//
//  Menu.swift
//  LC.Monitoring
//
//  Created by Урсолов Влад on 06.01.2024.
//

import Foundation
let menuItems: [MenuItem] = [
    MenuItem(name: "Аналитическая Сводка", link: "https://datalens.yandex.ru/1sz7xgsnx5dyp-monitoring-mobile"),
    MenuItem(name: "Активность", link: "#", subItems: [
        MenuItem(name: "Подразделения", link: "https://datalens.yandex.ru/mdkc0onkisv8a-monitoring-aktivnost-podrazdeleniy?state=28e3b83e56"),
        MenuItem(name: "Пользователи МИС", link: "https://datalens.yandex.ru/vmuyrh83u67yj-monitoring-aktivnost-polzovateley-mis"),
    ]),
    MenuItem(name: "Структура", link: "#", subItems: [
        MenuItem(name: "Структура ПО", link: "https://datalens.yandex.ru/kbicva0ddy6k8-monitoring-struktura-po"),
        MenuItem(name: "Реверс-структура", link: "https://datalens.yandex.ru/qhpu2u18otj8e-monitoring-revers-struktura-po?state=7cbc6b9d56"),
    ]),
    MenuItem(name: "Нагрузка", link: "#", subItems: [
        MenuItem(name: "Суточная", link: "https://datalens.yandex.ru/riuuli6arg5qf-monitoring-nagruzka-sutochnaya?state=f360e0aa56"),
        MenuItem(name: "Общая", link: "https://datalens.yandex.ru/nemzugt5zzeyb-monitoring-nagruzka"),
        MenuItem(name: "Ресурсы", link: "https://datalens.yandex.ru/tkwvy9lw788ah-monitoring-resursy?state=d44e055d56")
    ]),
]
