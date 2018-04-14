import * as React from 'react';
import * as ReactMarkdown from 'react-markdown';


export default class Level extends React.Component<any, any> {
  constructor(props) {
    super(props);
  }


  renderTasks(tasks) {
     return tasks && tasks.map(task => {
       return <ReactMarkdown source={ task.content } />;
     });
  }

  render() {
    const level_title = this.props.level == 'references' ? `Ongoing References` : `Level ${this.props.level}`;

    return(
      <div>
        <h3>{level_title}</h3>
        { this.renderTasks(this.props.tasks) }
      </div>
    )
  }
}
