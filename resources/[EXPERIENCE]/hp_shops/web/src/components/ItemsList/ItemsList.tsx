import React from 'react'
import * as S from './ItemsList.styled';
import { ShopItemTypes } from '../../types/ShopItemTypes';
import { faStore, faCartShopping } from '@fortawesome/free-solid-svg-icons';
import { BasketTypes } from '../../types/BasketTypes';

interface ItemsListProps {
  products: ShopItemTypes[];
  basket: BasketTypes[];
  setBasket: React.Dispatch<React.SetStateAction<BasketTypes[]>>;
  title: string;
}

const ItemsList = ({ products, setBasket, basket, title }: ItemsListProps) => {


  const addToCart = (product: string) => {
    const existingItemIndex = basket.findIndex((item) => item.item === product);
    if (existingItemIndex !== -1) {
      const updatedData = [...basket];
      updatedData[existingItemIndex].quantity += 1;
      setBasket(updatedData);
    } else {
      setBasket([...basket, { item: product, quantity: 1 }]);
    }
  };

  return (
    <S.ItemListContainer>
      <S.Heading>
        <S.ShopIcon icon={faStore} />  
        {title}
      </S.Heading>
      <S.ProductsContainer>
        {products.map((item, index) => {
        const gramsToKilograms = (grams:number) => {
          return (grams / 1000).toFixed(2);
        };
        const modifiedPrice = item.price.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
        return (
          <S.Product key={index}>
          <S.ProductInfo>
            <S.ProductName>{item.name}</S.ProductName>
            <S.ProductWeight>{gramsToKilograms(item.weight)}kg</S.ProductWeight>
          </S.ProductInfo>
           <img src={`assets/${item.name}.png`} />
          <S.ProductInfo>
            <S.ProductPrice><span style={{ color: "rgba(253,67,112,1)" }}>$</span>{modifiedPrice}</S.ProductPrice>
            <S.ProductBtn onClick={() => addToCart(item.name)} icon={faCartShopping} />
          </S.ProductInfo>
        </S.Product>
        )
})}
      </S.ProductsContainer>
    </S.ItemListContainer>
  )
}

export default ItemsList