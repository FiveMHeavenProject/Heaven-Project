import * as S from './Progressbar.styled';
import { ProgressbarDataType } from '../types/ProgressbarTypes';
import { useEffect, useState } from 'react';

function Progressbar({ data, closeProgressbar }: {
    data: ProgressbarDataType;
    closeProgressbar: () => void;
}) {
    const [state, setState] = useState<{
        percentage: number,
    }>({
        percentage: 0,
    });

    useEffect(() => {
        setState({
            percentage: 0,
        });
    }, [data]);

    const intervalTime = 10;

    useEffect(() => {
        const interval = setInterval(() => {
            setState((prevState) => {
                if (prevState.percentage < 100) {
                    return {
                        percentage: prevState.percentage + intervalTime / (data.time / intervalTime / 10),
                    };
                }
                closeProgressbar();
                return prevState;
            });
        }, intervalTime);
        return () => clearInterval(interval);
    }, [data]);


    return (
        <S.Progressbar>
            <S.ProgressbarFill percentage={state.percentage} color={data.bgColor} />
            <S.ProgressbarLabel color={data.textColor}>
                {data.label}
            </S.ProgressbarLabel>
        </S.Progressbar>
    )
}

export default Progressbar

