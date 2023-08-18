import * as S from './CarPurchase.styled';
import { faSackDollar } from '@fortawesome/free-solid-svg-icons';
import { faCreditCard } from '@fortawesome/free-solid-svg-icons';
import { CarTypes } from '../../types/CarTypes';

interface ICarPurchaseProps {
  setOpenCarPurchase:React.Dispatch<React.SetStateAction<boolean>>;
  selectedCar: CarTypes | undefined;
}

const CarPurchase = ({setOpenCarPurchase, selectedCar}:ICarPurchaseProps) => {


  const handleBuyCar = (paymentType:string) => {
    fetch(`https://hp_vehicleshop/Buy`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({modelcar:selectedCar?.model, paymenttype: paymentType})
      });
  }

  return (
    <S.Modal>
      <S.ModalContent>
        <S.BtnsContainer>
          <S.Btn onClick={() => handleBuyCar("cash")}><S.Icon icon={faSackDollar} /><S.IconText>Gotówka</S.IconText></S.Btn>
          <S.Btn onClick={() => handleBuyCar("bank")}><S.Icon icon={faCreditCard} /><S.IconText>Karta</S.IconText></S.Btn>
        </S.BtnsContainer>
        <S.ModalClose onClick={() => setOpenCarPurchase(false)}>Anuluj</S.ModalClose>
      </S.ModalContent>
    </S.Modal>
  )
}

export default CarPurchase