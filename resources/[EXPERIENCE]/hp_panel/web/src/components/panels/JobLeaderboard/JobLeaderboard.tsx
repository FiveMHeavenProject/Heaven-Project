import place1 from '../../../assets/place1.png';
import place2 from '../../../assets/place2.png';
import place3 from '../../../assets/place3.png';

const placesImages = [place1, place2, place3];

import * as S from './JobLeaderboard.styled.ts';

export const JobLeaderboard = ({ data }: {
  data?: {
    jobName: string;
    list: {
      charname: string;
      points: number;
    }[]
  }
}) => {

  if (!data) return null

  const top3 = data.list.slice(0, 3);
  const rest = data.list.slice(3);
  return (
    <S.Wrapper>
      <S.Grid>
        {top3.map((element, index) => {
          return (
            <S.GridItem key={index}>
              <S.PlaceAndPoints>
                <S.Place src={placesImages[index]} />
                <S.Points>{element.points} punktów</S.Points>
              </S.PlaceAndPoints>
              <S.Name>{element.charname}</S.Name>
            </S.GridItem>
          )
        })}
      </S.Grid>
      <S.List>
        {rest.map((element, index) => {
          return (
            <S.ListItem key={index}>
              <S.ListPlace>{index + 4}</S.ListPlace>
              <S.ListPoints>{element.points} punktów</S.ListPoints>
              <S.ListName>{element.charname}</S.ListName>
            </S.ListItem>
          )
        })}
      </S.List>
    </S.Wrapper>
  )
}
