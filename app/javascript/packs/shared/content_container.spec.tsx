import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as TestUtils from 'react-dom/test-utils';

import ContentContainer from "./content_container";


describe('ContentContainer', () => {
  it('it renders the title passed', () => {
    const props = { title: "test title"};
    const show = TestUtils.renderIntoDocument(
      <ContentContainer {...props}/>
    );

    const learningTrailsShowNode = ReactDOM.findDOMNode(show);

    expect(learningTrailsShowNode.textContent).toEqual(props.title);
  });

  it('it shows children components', () => {
    const expected = "child text";
    const props = { title: "test title"};
    class Child extends React.Component {
      render() {
        return <div className="test">{expected}</div>
      }
    }

    const show = TestUtils.renderIntoDocument(
      <ContentContainer {...props}>
        <Child />
      </ContentContainer>
    );

    const parent = ReactDOM.findDOMNode(show);
    const actual = parent.getElementsByClassName("test")
      .item(0)
      .textContent;

    expect(actual).toEqual(expected)
  });
});
