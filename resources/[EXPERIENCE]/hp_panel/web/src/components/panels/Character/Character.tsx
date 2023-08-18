
import { CharacterType } from '../../../types/CharacterTypes.ts';
import * as S from './Character.styled.ts';

export const Character = ({ data }: {
  data?: CharacterType
}) => {

  if (!data) return null

  const elements = [
    [
      data.name,
      data.ssn,
    ],
    [data.hp_points],
    [
      data.jobName,
      data.jobPosition,
      data.onDuty
    ],
    [
      data.currentSessionTime,
      data.totalPlayTime
    ],
    [data.created_at],
    [data.stamina],
    [data.strength],
    [data.dexterity],
  ]

  return (
    <S.Wrapper>

      {elements.map((element, index) => {
        return (
          <S.PanelElement key={index} span={element.length}>
            {
              element.map((el, index) => {
                if (el.label === "Na służbie" && !el.value) {
                  el.value = "Nie"
                }
                if (el.value === "unemployed" || el.value === "Unemployed") {
                  el.value = "Bezrobotny"
                }
                return (
                  <S.PanelElementBox key={index}>
                    <S.PanelElementBoxLabel>{el.label}</S.PanelElementBoxLabel>
                    <S.PanelElementBoxValue>{el.value}</S.PanelElementBoxValue>
                  </S.PanelElementBox>
                )
              })
            }
          </S.PanelElement>
        )
      })}
    </S.Wrapper>
  )
}
