import * as S from './Basket.styled';
import { faCartShopping, faCreditCard, faSackDollar, faPlus, faMinus, faTrash } from '@fortawesome/free-solid-svg-icons';
import { BasketTypes } from '../../types/BasketTypes';

interface IBasketProps {
  basket: BasketTypes[];
  setBasket: React.Dispatch<React.SetStateAction<BasketTypes[]>>;
  title: string;
}


const Basket = ({ basket, setBasket, title }: IBasketProps) => {


  const updateQuantity = (index: number, newQuantity: number) => {
    if (!isNaN(newQuantity) && newQuantity >= 1) {
    const updatedData = [...basket];
    updatedData[index].quantity = newQuantity;
    setBasket(updatedData);
    }
  };

  const handleInput = (event: React.ChangeEvent<HTMLInputElement>, index: number) => {
    const newQuantity = parseInt(event.target.value);
    if (!isNaN(newQuantity) && newQuantity >= 1) {
      updateQuantity(index, newQuantity);
    }
  }

  const removeItem = (index: number) => {
    const updatedData = basket.filter((_, i) => i !== index);
    setBasket(updatedData);
  };

  const buyProducts = (paymentType: string) => {
    fetch(`https://hp_shops/Buy`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({ itemsArray: basket, paymentType: paymentType, title: title })
    });
  }

  



  return (
    <S.BasketContainer>
      <S.Heading>
        <S.BasketIcon icon={faCartShopping} />
        Koszyk
      </S.Heading>
      <S.Basket>
        {basket.map((item, index) => (
          <S.BasketItem key={index}>
            <S.BasketItemName>{item.item}</S.BasketItemName>
            <S.BasketItemQuantity>
              <S.BasketItemQuantityBtn onClick={() => updateQuantity(index, item.quantity - 1)} icon={faMinus} />
              <S.BasketItemQuantityInput onChange={(event) => handleInput(event, index)} min={1} value={item.quantity} />
              <S.BasketItemQuantityBtn onClick={() => updateQuantity(index, item.quantity + 1)} icon={faPlus} />
              <S.BasketItemRemoveBtn onClick={() => { removeItem(index) }} icon={faTrash} />
            </S.BasketItemQuantity>
          </S.BasketItem>
        ))}
      </S.Basket>
      <S.BtnContainer>
        <S.Btn onClick={() => buyProducts("bank")}>
          <S.BtnIcon  icon={faCreditCard} />
          Karta
        </S.Btn>
        <S.Btn onClick={() => buyProducts("cash")}>
          <S.BtnIcon icon={faSackDollar} />
          Gotówka
        </S.Btn>
      </S.BtnContainer>
    </S.BasketContainer>
  )
}

export default Basket