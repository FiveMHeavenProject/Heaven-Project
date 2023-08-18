import { Dispatch, SetStateAction } from "react";

export const setMockData = (setData: Dispatch<SetStateAction<{}>>) => {
    setData({
        character: {
            currentSessionTime: {
                "value": "Czas: 00:01:21",
                "label": "Czas sesji"
            },
            ssn: {
                "value": 84,
                "label": "SSN"
            },
            created_at: {
                "value": "2023-06-20 21:03:47",
                "label": "Data utworzenia postaci"
            },
            name: {
                "value": "Adam Małysz",
                "label": "Imię i nazwisko"
            },
            jobPosition: {
                "value": "Unemployed",
                "label": "Stanowisko"
            },
            onDuty: {
                "value": false,
                "label": "Na służbie"
            },
            jobName: {
                "value": "Unemployed",
                "label": "Aktualna praca"
            },
            hp_points: {
                "value": 1,
                "label": "Punkty HP"
            },
            stamina: {
                "value": 1,
                "label": "Punkty wytrzymałości"
            },
            strength: {
                "value": 1,
                "label": "Punkty siły"
            },
            dexterity: {
                "value": 1,
                "label": "Punkty zręczności"
            },
            totalPlayTime: {
                "value": "0 dni",
                "label": "Czas na serwerze"
            }
        },
        jobLeaderboard: {
            jobName: "LSPD",
            list: [
                {
                    charname: "Test Test",
                    points: 122,
                },
                {
                    charname: "Jack Harris",
                    points: 120,
                },
                {
                    charname: "Adam Małysz",
                    points: 110,
                },
                {
                    charname: "Krzysztof Rutkowski",
                    points: 100,
                },
                {
                    charname: "Zbigniew Stonoga",
                    points: 84,
                },
                {
                    charname: "Janusz Korwin-Mikke",
                    points: 80,
                },
                {
                    charname: "Janusz Tracz",
                    points: 70,
                },
                {
                    charname: "Janusz Palikot",
                    points: 60,
                },
                {
                    charname: "Janusz Rewiński",
                    points: 50,
                },
                {
                    charname: "Janusz Gajos",
                    points: 40,
                },
            ]
        }
    });
}

