import styled from "styled-components"

export const Progressbar = styled.div`
    position: absolute;
    bottom: 200px;
    left: 50%;
    transform: translateX(-50%);
    width: 300px;
    height: 40px;
    border-radius: 10px;
    overflow: hidden;
    background-color: rgba(0, 0, 0, 0.25);
    transition: background-color 0.2s ease-in-out
`;

export const ProgressbarFill = styled.div<{ percentage: number; color: string }>`
    height: 100%;
    width: ${props => props.percentage}%;
    background-color: ${props => props.color};
    position: absolute;
    top: 0;
    left: 0;
    transition: width 0.01s linear;
`;

export const ProgressbarLabel = styled.div<{ color: string }>`
    font-size: 1rem;
    font-weight: 500;
    text-align: center;
    color: ${props => props.color};
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
`;