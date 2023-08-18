import { styled } from "styled-components";


export const CarInfoWrapper = styled.div`
    position: absolute;
    right: 50px;
    top: 50%;
    transform: translateY(-40%);
    height: fit-content;
    min-width: 20%;
`;


export const StatsContainer = styled.div`
    display: flex;
    padding: 25px;
    flex-direction: column;
    align-items: center;
    gap: 15px;
    background-color: rgba(0,0,0,0.7);
`;

export const SingleStat = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center ;
    gap: 5px;
    width: 100%;
`;

export const StatName = styled.p`
    font-size: 23px;
    font-weight: 700;
    text-transform: uppercase;
    color: white;
`;


export const Bar = styled.div`
    height: 100%;
    width: 100%;
    background-color: rgba(255, 255, 255, 0.4);
    display: flex;
    align-items: flex-start;
    justify-content: flex-start;
`;

export const Percent = styled.div<{width:number}>`
    height: 15px;
    background-color:#fd4370;
    width: ${(props) => props.width}%;
    transition: width .3s;
    box-shadow: 0px 0px 10px 0px #fd4370;
`;



export const InfoContainer = styled.div`
    margin-top: 14px;
    background-color: rgba(0,0,0,0.7);
    padding: 25px;
    display: flex;
    flex-direction: column;
    gap: 10px;
`;


export const BtnsContainer = styled.div`
    display: flex;
    flex-direction: column;
    gap: 10px;
`;

export const Btn = styled.button`
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px 40px;
    font-size: 25px;
    color: white;
    text-align: center;
    border: none;
    background-color: rgba(0,0,0, 0.7);
    text-transform: uppercase;
    font-weight: 700;
    cursor: pointer;
    transition: .1s;
    &:hover {
        background-color: #fd4370;
    }
`;