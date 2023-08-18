import { useEffect } from "react";
import { CarTypes } from "../../types/CarTypes";
import * as S from './SingleCategory.styled.ts';

interface ISingleCategoryProps {
  categoryData: CarTypes[];
  selectedCar:CarTypes | undefined;
  setSelectedCar:React.Dispatch<React.SetStateAction<CarTypes | undefined>>;
}

const SingleCategorie = ({categoryData, selectedCar, setSelectedCar}: ISingleCategoryProps) => {


  const handleFetchCar = (car:CarTypes) => {
    if(car.model === selectedCar?.model) {
      return;
    } else {
        fetch(`https://hp_vehicleshop/SpawnVehicle`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({modelcar:car.model,price:car.price })
      });
        setSelectedCar(car)
    }
  }

  const handleClickCar = (car: CarTypes) => {
    handleFetchCar(car)
  } 


  const sortedCategoryData = [...categoryData].sort((a, b) => a.price - b.price);

  useEffect(() => {
    if (categoryData && categoryData.length > 0) {
      const firstItem = sortedCategoryData[0];
      if (firstItem && firstItem.model && firstItem.price) {
        handleFetchCar(firstItem)
      }}
  }, [categoryData])


  return (
    <S.CategoryWrapper>
      {sortedCategoryData.map((car, index) => {
      const modifiedPrice = car.price.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
      return (
        <S.CategoryItem style={{boxShadow: selectedCar?.model === car.model ? 'inset 0px 0px 20px -5px #fd4370' : 'unset'}}
           onClick={() => handleClickCar(car)} key={index}>
          <S.ItemTextLeft>
            <S.ItemModel>{car.model}</S.ItemModel>
            <S.ItemBrand>{car.brand}</S.ItemBrand>
          </S.ItemTextLeft>
          <S.ItemPrice>{modifiedPrice}<span style={{color: "#fd4370", fontWeight: "700", marginLeft: "1px"}}>$</span></S.ItemPrice>
        </S.CategoryItem>
      )
      })}
    </S.CategoryWrapper>
  )
}

export default SingleCategorie