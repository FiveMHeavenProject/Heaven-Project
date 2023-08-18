import { useState } from "react"
import * as S from './CarStats.styled.ts';
import { CarStatsTypes } from "../../types/CarStatsTypes"
import { CarTypes } from "../../types/CarTypes.ts";


interface ICarStatsProps {
  selectedCar: CarTypes | undefined;
  setOpenShop:React.Dispatch<React.SetStateAction<boolean>>;
  setSelectedCar:React.Dispatch<React.SetStateAction<CarTypes | undefined>>;
  setOpenCarPurchase:React.Dispatch<React.SetStateAction<boolean>>;
}

const CarStats = ({selectedCar, setOpenShop, setSelectedCar, setOpenCarPurchase}:ICarStatsProps) => {


const [carStatsData, setCarStatsData] = useState<CarStatsTypes>()

window.addEventListener('message', (event) => {
  if(event.data.type == "updateVehicleInfos") {
    let data = event.data
    setCarStatsData(data.data)
  }
})

const acceleration = carStatsData?.acceleration ?? 0;
const maxSpeed = carStatsData?.maxSpeed ?? 0;
const breaking = carStatsData?.breaking ?? 0;
const traction = carStatsData?.traction ?? 0;


const handleTestClick = () => {
  fetch(`https://hp_vehicleshop/TestDrive`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({vehicleModel:selectedCar?.model})
  });
  setOpenShop(false)
  setSelectedCar(undefined)
}


  return (
    <S.CarInfoWrapper>
      <S.StatsContainer>
        <S.SingleStat>
          <S.StatName>Przyśpieszenie</S.StatName>
          <S.Bar>
            <S.Percent width={Math.ceil(100 * acceleration)} />
          </S.Bar>
        </S.SingleStat>
        <S.SingleStat>
          <S.StatName>Vmax</S.StatName>
          <S.Bar>
            <S.Percent width={Math.ceil(maxSpeed * 1.4)} />
          </S.Bar>
        </S.SingleStat>
        <S.SingleStat>
          <S.StatName>Hamulec</S.StatName>
          <S.Bar>
            <S.Percent width={Math.ceil(100 * breaking)} />
          </S.Bar>
        </S.SingleStat>
        <S.SingleStat>
          <S.StatName>Trakcja</S.StatName>
          <S.Bar>
            <S.Percent width={Math.ceil(10 * traction * 1.6)} />
          </S.Bar>
        </S.SingleStat>
      </S.StatsContainer>
      <S.InfoContainer>
      <S.BtnsContainer>
          <S.Btn onClick={handleTestClick}>Test</S.Btn>
          <S.Btn onClick={() => setOpenCarPurchase(true)}>Kup</S.Btn>
        </S.BtnsContainer>
      </S.InfoContainer>
    </S.CarInfoWrapper>
  )
}

export default CarStats