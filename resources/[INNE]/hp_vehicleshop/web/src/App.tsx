import { useEffect, useState } from "react";
import CarCategories from "./components/CarCategories/CarCategories"
import { CarTypes } from "./types/CarTypes";
import {CarDataTypes} from "./types/CarDataTypes"
import SingleCategory from "./components/SingleCategory/SingleCategory";
import CarStats from "./components/CarStats/CarStats";
import CarPurchase from "./components/CarPurchase/CarPurchase";

function App() {

  const [openShop, setOpenShop] = useState(false)
  const [openCarPurchase, setOpenCarPurchase] = useState(false)

  const [data, setData] = useState<CarDataTypes>({});

  const allCategories = Object.keys(data);
  const [category, setCategory] = useState<string>(allCategories[0])
  const [categoryData, setCategoryData] = useState<CarTypes[]>(data[0])

  const [selectedCar, setSelectedCar] = useState<CarTypes | undefined>()

  

  useEffect(() => {
    const filteredData = data[category] || [];
      setCategoryData(filteredData);
  }, [category, data])


  window.addEventListener('message', (event) => {
    if(event.data.type == "display") {
      let data = event.data
      setData(data.data)
      setOpenShop(true)
    } else if (event.data.type == "hide") {
      setOpenShop(false)
      setOpenCarPurchase(false)
      setSelectedCar(undefined)
    }
  })


  const rotateCar = (direction: string, rot: boolean) => {
    fetch(`https://hp_vehicleshop/rotate`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ key: direction, rot: rot })
          });
  }

  const closeShop = () => {
    setOpenShop(false)
    setOpenCarPurchase(false)
    setSelectedCar(undefined)
        fetch(`https://hp_vehicleshop/Close`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
      });
  }

  window.addEventListener('keydown', (event) => {
    switch (event.key) {
      case "Escape":
          closeShop()
          break;
      case "a":
          rotateCar("left", true)
          break;
      case "d":
        rotateCar("right", true)
          break;
  }})

  window.addEventListener('keyup', (event) => {
    switch (event.key) {
      case "a":
          rotateCar("left", false)
          break;
      case "d":
        rotateCar("right", false)
          break;
  }})



  return (
    <>
     {openShop &&
      <>
        <CarCategories setCategory={setCategory} allCategories={allCategories}  />
        <SingleCategory categoryData={categoryData} selectedCar={selectedCar} setSelectedCar={setSelectedCar}  />
        <CarStats selectedCar={selectedCar} setOpenShop={setOpenShop} setSelectedCar={setSelectedCar} setOpenCarPurchase={setOpenCarPurchase}  />
        {openCarPurchase && <CarPurchase setOpenCarPurchase={setOpenCarPurchase} selectedCar={selectedCar} /> }
      </>}
    </>
  )
}

export default App

