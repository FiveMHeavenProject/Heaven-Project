
import { CharacterType } from '../types/CharacterTypes.ts';
import { JobLeaderboardType } from '../types/JobLeaderboardTypes.ts';
import * as S from './Panel.styled.ts';
import { Character } from './panels/Character/Character.tsx';
import { JobLeaderboard } from './panels/JobLeaderboard/JobLeaderboard.tsx';

export const Panel = ({ close, data, panelName }: {
  close: () => void;
  data: {
    character?: CharacterType
    jobLeaderboard?: JobLeaderboardType
  },
  panelName: string;
}) => {

  const header = () => {
    switch (panelName) {
      case 'character':
        return 'Postać';
      case 'job-leaderboard':
        if (!data?.jobLeaderboard?.jobName) return 'Ranking pracowników';
        const firstLetter = data?.jobLeaderboard?.jobName.charAt(0).toUpperCase();
        const formattedPanelName = firstLetter + data?.jobLeaderboard?.jobName.slice(1);
        return `Ranking pracowników - ${formattedPanelName}`;
    }
  }

  return (
    <S.PanelWrapper>
      <S.Panel>
        <S.PanelHeader>
          <S.PanelTitle>{header()}</S.PanelTitle>
          <S.CloseButton onClick={close} />
        </S.PanelHeader>
        <S.PanelBody>

          {panelName === 'character' ? <Character data={data.character} /> : null}
          {panelName === 'job-leaderboard' ? <JobLeaderboard data={data.jobLeaderboard} /> : null}

        </S.PanelBody>
      </S.Panel>
    </S.PanelWrapper>
  )
}
