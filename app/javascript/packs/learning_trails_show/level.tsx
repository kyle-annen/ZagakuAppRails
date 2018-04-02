import * as React from 'react';

export default class Level extends React.Component<any, any> {
  constructor(props) {
    super(props);
  }

  render() {
    const level_title = this.props.level == 'references' ?
    `Ongoing References` :
    `Level ${this.props.level}`;

    const tasks = this.props.tasks && this.props.tasks.map((task) => {
      return <p>{JSON.stringify(task.content)}</p>
    });

    return(
      <div>
        <h3>{level_title}</h3>
        { tasks }
      </div>
    )
  }
}
