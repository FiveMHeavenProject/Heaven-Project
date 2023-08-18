import { styled } from "styled-components";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

export const BasketContainer = styled.div`
    flex: 1;
    background-color: rgba(0,0,0,0.7);
    display: flex;
    flex-direction: column;
`;


export const Heading = styled.h1`
    display: flex;
    justify-content: center;
    gap: 7px;
    font-size: 40px;
    text-transform: uppercase;
    font-weight: 700;
    border-bottom: 2px solid white;
    padding:25px ;
`;

export const BasketIcon = styled(FontAwesomeIcon)`
    color: white;
    font-size: 40px;
`;


export const Basket = styled.div`
    display: flex;
    flex-direction: column;
    gap: 15px;
    padding: 20px;
    flex-grow: 3;
    overflow-y: auto;

    &::-webkit-scrollbar {
        width: 5px; 
    }
    &::-webkit-scrollbar-thumb {
        background-color:#fd4370;
    }
`;

export const BasketItem = styled.div`
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
`;

export const BasketItemName = styled.p`
    font-size: 20px;
    font-weight: 500;
    text-transform: capitalize;
    padding: 8px;
    background-color: rgba(0,0,0,0.65);
`;

export const BasketItemQuantity = styled.p`
    display: flex;
    align-items: center;
    align-items: stretch;
    gap: 5px;
    font-size: 25px;
    font-weight: 500;
    background-color: rgba(0,0,0,0.65);
`;

export const BasketItemQuantityInput = styled.input`
    background-color: transparent;
	width: 2vw;
	color: white;
	text-align: center;
	border: none;
	font-weight: 700;
    font-size: 17px;
   &:focus {
    outline: none;
   }
`;

export const BasketItemQuantityBtn = styled(FontAwesomeIcon)`
    /* background-color: transparent; */
	color: white;
	border: none;
	padding: 8px;
    cursor: pointer;
    font-size: 17px;
`;
export const BasketItemRemoveBtn = styled(FontAwesomeIcon)`
    background-color: rgba(253,67,112,.65);
	color: white;
	border: none;
    font-size: 17px;
    cursor: pointer;
    padding: 8px;
`;



export const BtnContainer = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    padding: 20px;
`;


export const Btn = styled.div`
    display: flex;
    flex: 1;
    align-items: center;
    justify-content: center;
    gap: 5px;
    background-color: rgba(253,67,112,.65);
    font-size: 25px;
    padding-block:7px;
    text-transform: capitalize;
    font-weight: 500;
    cursor: pointer;
`;

export const BtnIcon = styled(FontAwesomeIcon)`
    color: white;
    font-size: 20px;
`;



