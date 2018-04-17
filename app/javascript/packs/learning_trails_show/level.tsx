import * as React from 'react';
import * as ReactMarkdown from 'react-markdown';


export default class Level extends React.Component<any, any> {
  constructor(props) {
    super(props);
  }

  //these are intentionally left identical due to the different
  //styles to be added.
  renderTasks(tasks) {
     return tasks && tasks.map(task => {
       return <ReactMarkdown source={ task.content } />;
     });
  }

  //these are intentionally left identical due to the different
  //styles to be added.
  renderGoals(goals) {
    return goals && goals.map(goal => {
      return <ReactMarkdown source={ goal.content } />;
    })
  }

  render() {
    const level_title = this.props.level == 'references' ? `Ongoing References` : `Level ${this.props.level}`;

    return(
      <div>
        <h3>{level_title}</h3>
        <h5>Tasks</h5>
        { this.renderTasks(this.props.tasks) }
        <h5>Goals</h5>
        { this.renderGoals(this.props.goals) }
      </div>
    )
  }
}
