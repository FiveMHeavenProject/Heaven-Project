import { styled } from "styled-components";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';


export const Modal = styled.div` 
  position: fixed; 
  z-index: 1000; 
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: hidden; 
`;


export const ModalContent = styled.div`
  position: relative;
  top: 50%;
  transform: translateY(-50%);
  background-color: rgba(0,0,0,0.7);
  margin: auto; 
  padding: 20px;
  width: 20%; 
  min-height: 20%;
  border-radius: 10px;
`;


export const ModalClose = styled.div`
    width: 100%;
    height: 10%;
    text-align: center;
    font-size: 27px;
    text-transform: uppercase;
    margin-top: 15px;
    padding-block: 10px;
    border: 2px solid #fd4370;
    color: white;
    font-weight: 700;
    cursor: pointer;
    transition: all .3s;

    &:hover {
        background-color: #fd4370;
    }
`;

export const BtnsContainer = styled.div`
    display: flex;
    align-items: center;
    gap: 15px;
    width: 100%;
    height: 90%;
`;

export const Btn = styled.div`
    display: flex;
    flex-direction: column;
    gap: 5px;
    align-items: center;
    justify-content: center;
    border: 2px solid #fd4370;
    color: white;
    width: 50%;
    height: fit-content;
    cursor: pointer;
    transition: all .3s;
    padding-block: 40px; 

    &:hover {
        background-color: #fd4370;
    }
`;

export const Icon = styled(FontAwesomeIcon)`
    color: white;
    width: 50px;
    height: 50px;
`;


export const IconText = styled.p`
    font-size: 20px;
    font-weight: 700;
    text-transform: uppercase;
`;
