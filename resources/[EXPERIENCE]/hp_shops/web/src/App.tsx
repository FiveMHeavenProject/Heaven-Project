import { useState } from "react"
import { ShopItemTypes } from "./types/ShopItemTypes"
import * as S from './App.styled';
import ItemsList from "./components/ItemsList/ItemsList";
import Basket from "./components/Basket/Basket";
import { BasketTypes } from "./types/BasketTypes";


function App() {

  const [products, setProducts] = useState<ShopItemTypes[]>([])
  const [basket, setBasket] = useState<BasketTypes[]>([])
  const [title, setTitle] = useState<string>("")


  window.addEventListener('message', (event) => {
    const data = event.data
    if(data.data) {
      setProducts(data.data)
      setTitle(data.title)
    } else if (event.data.type == "hide") {
      setProducts([])
      setBasket([])
      setTitle("")
    }
  })

  const closeShop = () => {
      setProducts([])
      setBasket([])
        fetch(`https://hp_shops/Close`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
      });
  }

  window.addEventListener('keydown', (event) => {
    if(event.key === "Escape") {
      closeShop();
    }
  })

  return (
    <>
    {products.length > 0 && 
      <S.ShopContainer>
      <ItemsList products={products} basket={basket} setBasket={setBasket} title={title} />
      <Basket basket={basket} setBasket={setBasket} title={title} />
    </S.ShopContainer>
  }
  </>
  )
}

export default App
