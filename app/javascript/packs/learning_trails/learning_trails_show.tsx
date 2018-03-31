import * as React from 'react';
import * as ReactDOM from 'react-dom';

interface ShowProps { name: string;  }

const LearningTrailsShow = (props: ShowProps) => (
        <div><p>{props.name}!</p></div>
);

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <LearningTrailsShow name='Learning Trails Show' />,
    document.body.appendChild(document.createElement('div')),
  )
});
