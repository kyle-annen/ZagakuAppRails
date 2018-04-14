import * as React from 'react';
import {} from 'jasmine';
import TopicContainer from "../packs/learning_trails_show/topic_container";
import {ShallowWrapper, shallow} from "enzyme"
import {IApi} from "../apis/iapi";

class FakeApi implements IApi {
  get (model: string, id: number): Promise<object> {
    return Promise.resolve(
      {
        topic: {
          id: id,
          category_id: 1,
          name: "Test Title",
          summary: "Test Summary"
        },
        user_lessons: {},
        parameters: {model: model, id: id}}
    )
  }
}

const testProps = {
  id: 1,
  api: new FakeApi
};

let child: ShallowWrapper<undefined, undefined>;

beforeEach(() =>
  child = shallow(<TopicContainer {...testProps}/>));

describe('TopicContainer', () => {

  it("should render without error", () => {
    expect(child.length).toBe(1);
  });

  it('calls api with id and model', () => {

  });
});
